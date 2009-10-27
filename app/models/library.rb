class Library < ActiveRecord::Base

  public_resource_for :read, :index

  has_many :tracks, :dependent => :destroy
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
    returning find_or_create_with({
      :name => source.name.get
    }, {
      :persistent_id => source.persistent_ID.get
    }, true) do |library|
      if library.new_or_deleted_before_save?
        juggernaut_message "Importing new library #{library.name}. Big libraries take a while (this one has #{library.tracks.count} tracks), but each track will be available as soon as it's imported."
      end
    end
  end

  def self.stats
    returning({
      :library_count => active.count,
      :song_count => Song.active.count,
      :duration => active.sum {|l| l.duration }
    }) do |hsh|
      hsh.update({
        :library_count_str => "#{hsh[:library_count].commas} #{hsh[:library_count] == 1 ? 'library' : 'libraries'}",
        :song_count_str => "#{hsh[:song_count].commas} #{hsh[:song_count] == 1 ? 'song' : 'songs'}",
        :duration_str => hsh[:duration].xsecs
      })
    end
  end

  def self.active
    select {|l| l.active }
  end

  def import
    if source.nil?
      if active?
        puts "Source for #{display_name} not available, marking as offline."
        adjust :active => false
      end
    else
      source_duration = source.duration.get || 0
      if source_duration > 0 #source duration is 0 while the library is being connected
        adjust :active => true unless active?
        if duration == source_duration && tracks.dirty.empty?
          # puts "Track count for #{display_name} hasn't changed, skipping."
        else
          if new_or_deleted_before_save?
            puts "Importing new library #{display_name}."
          else
            puts "Updating library #{display_name}, currently #{tracks.count} tracks."
          end
          import_tracks
          adjust :duration => source_duration
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

  private

  def import_tracks
    have = Track.clean_persistent_ids_for self
    want = source_tracks.keys
    have_and_dont_want, want_and_dont_have = have - want, want - have

    if have_and_dont_want.empty? && want_and_dont_have.empty?
      puts "Nothing to update for #{display_name}."
    else
      original_track_count = tracks.count

      puts "This library contains #{original_track_count - have.length} dirty track#{'s' unless original_track_count - have.length == 1} that will be re-imported." unless original_track_count == have.length

      have_and_dont_want.each {|old_id|
        old_track = tracks.find_by_persistent_id(old_id)
        puts "Track #{old_track.library.name}/#{old_track.persistent_id}: #{old_track.name} disappeared, removing."
        old_track.destroy
      }
      want_and_dont_have.each {|new_id| Track.import source_tracks[new_id], self }

      touch :imported_at
      puts "Finished importing #{display_name} - library went from #{original_track_count} to #{tracks.count} tracks (#{want_and_dont_have.length} added, #{have_and_dont_want.length} removed).\n"
    end
  end

  def self.juggernaut_message message
    call_via_juggernaut :message_event, Library.stats.merge(:message => message).to_json
  end

  def juggernaut_message message
    self.class.juggernaut_message message
  end

end
