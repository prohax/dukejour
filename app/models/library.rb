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
    find_or_create_with({
      :name => source.name.get
    }, {
      :persistent_id => source.persistent_ID.get
    }, true)
  end

  def import
    if source.nil?
      if active?
        puts "Source for #{display_name} not available, marking as offline."
        adjust :active => false
      end
    else
      adjust :active => true unless active?
      if library_track_count == source.tracks.get.size && tracks.dirty.empty?
        puts "Track count for #{display_name} hasn't changed, skipping."
      else
        if new_or_deleted_before_save?
          puts "Importing new library #{display_name}."
        else
          puts "Updating library #{display_name}, currently #{tracks.count} tracks."
        end
        import_tracks
        adjust :library_track_count => source.tracks.get.length
      end
    end
  end

  def source
    detected_source = iTunes.sources.detect {|l| l.name.get == name }
    detected_source.library_playlists.first unless detected_source.nil?
  end

  def source_tracks
    if @source_tracks.nil?
      @source_tracks = {}
      source.tracks.get.each {|t|
        @source_tracks[t.persistent_ID.get] = t if t.enabled.get && !t.podcast.get && t.video_kind.get == :none
      }
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

end
