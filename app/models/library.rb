require 'i_tunes_interface'
include ITunes

class Library
  include Mongoid::Document
  include HammockMongo
  field :persistent_id
  field :name
  field :active, :type => Boolean
  field :imported_at, :type => Time
  field :duration, :type => Integer, :default => 0
  field :current_persistent_track_ids, :type => Array

  validates_presence_of :persistent_id, :name
  validates_uniqueness_of :name

  before_create :clean_strings
  def clean_strings
    name.strip! unless name.nil?
  end

  def display_name
    "'#{name}' (#{persistent_id})"
  end

  def self.create_for source
    find_or_create_with({
      :name => source.name.get
    }, {
      :persistent_id => source.persistent_ID.get
    }, true)
  end

  def self.stats
    returning({
      :library_count => active.count,
      :song_count => Song.active.count,
      :duration => active.map(&:duration).sum
    }) do |hsh|
      hsh.update({
        :library_count_str => "#{hsh[:library_count].commas} #{hsh[:library_count] == 1 ? 'library' : 'libraries'}",
        :song_count_str => "#{hsh[:song_count].commas} #{hsh[:song_count] == 1 ? 'song' : 'songs'}",
        :duration_str => hsh[:duration].xsecs
      })
    end
  end

  def self.active
    where(:active => true)
  end

  def import!
    if source.nil?
      if active?
        song_delta_via_juggernaut "#{name} just went offline", :leaving => true do
          update_attributes :active => false
        end
      end
    else
      source_duration = source.duration.get || 0
      if source_duration > 0 #source duration is 0 while the library is being connected
        unless active?
          if new_before_save?
            update_attributes :active => true
          else
            song_delta_via_juggernaut "Welcome back, #{name}!" do
              update_attributes :active => true
            end
          end
        end
        if duration == source_duration #&& tracks.dirty.empty?
          # puts "Track count for #{display_name} hasn't changed, skipping."
        else
          if new_before_save? || duration.zero?
            juggernaut_library_message "Hello #{name}! Importing now - each track is playable as soon as it's imported."
          else
            duration_delta = source_duration - duration
            juggernaut_library_message "Hey, #{name} #{duration_delta < 0 ? 'shrank' : 'grew'} by #{duration_delta.abs.xsecs} - importing the difference."
          end
          song_delta_via_juggernaut "Finished #{new_before_save? ? 'importing' : 'updating'} #{name} -" do
            import_tracks!
            update_attributes :duration => source_duration
          end
        end
      end
    end
  end

  def source
    detected_source = iTunes.sources.detect {|l| l.name.get == name }
    detected_source.library_playlists.first unless detected_source.nil?
  end

  def source_tracks
    if @source_tracks.nil?
      gt = Time.now
      puts "Loading source tracks into memory."
      @source_tracks = Hash.new { |h,k| h[k] = [] }
      cols = %w[persistent_ID enabled podcast video_kind artist album name year duration track_number track_count disc_number disc_count bit_rate kind]
      col_data = cols.map { |c| source.tracks.send(c.to_sym).get }
      puts "Applescript done (#{Time.now - gt} seconds). Everything in memory now, hashifying."
      col_data.transpose.each { |row|
        t = Hash[*cols.zip(row).flatten]
        @source_tracks[t['persistent_ID']] = t if t['enabled'] && !t['podcast'] && t['video_kind'] == :none
      }
      puts "Done (total #{Time.now - gt} seconds)."
    end
    @source_tracks
  end

  def import_tracks!
    want = source_tracks.keys
    current_persistent_track_ids ||= []
    have_and_dont_want, want_and_dont_have = current_persistent_track_ids - want, want - current_persistent_track_ids

    if have_and_dont_want.empty? && want_and_dont_have.empty?
      puts "Nothing to update for #{display_name}."
    else
      original_track_count = current_persistent_track_ids.length

      puts "This library contains #{original_track_count - current_persistent_track_ids.length} dirty track#{'s' unless original_track_count - current_persistent_track_ids.length == 1} that will be re-imported." unless original_track_count == current_persistent_track_ids.length

      have_and_dont_want.each {|old_id|
        old_track = tracks.find_by_persistent_id(old_id)
        puts "Track #{old_track.library.name}/#{old_track.persistent_id}: #{old_track.name} disappeared, removing."
        old_track.destroy
      }
      want_and_dont_have.each {|new_id| Track.import! source_tracks[new_id], self }

      current_persistent_track_ids = want
      save!

      update_attributes :imported_at => Time.now
      puts "Finished importing #{display_name} - library went from #{original_track_count} to #{current_persistent_track_ids.count} tracks (#{want_and_dont_have.length} added, #{have_and_dont_want.length} removed).\n"
    end
  end

  def song_delta_via_juggernaut message, opts = {}, &block
    prev_active_songs = Song.active.count
    block.call
    active_songs_delta = (Song.active.count - prev_active_songs).abs
    if opts[:leaving]
      if active_songs_delta.zero?
        juggernaut_library_message "#{message}, but no songs went offline since they're all on other libraries."
      else
        juggernaut_library_message "#{message}, taking #{active_songs_delta} song#{'s' unless active_songs_delta == 1} with it."
      end
    else
      if active_songs_delta.zero?
        juggernaut_library_message "#{message} all the tracks were already available in other libraries."
      else
        juggernaut_library_message "#{message} #{active_songs_delta} more song#{'s' unless active_songs_delta == 1} #{active_songs_delta == 1 ? 'is' : 'are'} online now."
      end
    end
  end

  def self.juggernaut_library_message message
    JuggernautHelpers.juggernaut_message message, {
      :stats => Library.stats,
#      # upcoming doesn't work yet
#      :entries => []# Entry.upcoming.map {|e| {:id => e.id, :active => e.active?} }
    }
  end

  def juggernaut_library_message message
    self.class.juggernaut_library_message message
  end

end
