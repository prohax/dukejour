class Library < ActiveRecord::Base
  include OSAHelpers

  public_resource

  has_many :tracks, :dependent => :destroy
  validates_presence_of :persistent_id, :name
  validates_uniqueness_of :name

  def self.import source
    returning find_or_create_with({
      :name => source.name
    }, {
      :persistent_id => source.persistent_id
    }, true) do |library|
      count_before_import = library.tracks.count
      if library.new_or_deleted_before_save?
        puts "Importing new library #{source.persistent_id} (#{source.name})."
      else
        puts "Re-importing from #{source.name} - already have #{count_before_import} tracks."
      end
      library.import_tracks
      puts "Finished importing library #{source.persistent_id} - #{source.name}, #{library.tracks.count - count_before_import} tracks added, #{library.tracks.count} total."
    end
  end

  def import_tracks
    source_tracks.each {|t| Track.import t, self }
  end

  def source
    self.class.all_sources.detect {|l|
      l.persistent_id == persistent_id
    }.library_playlists[0]
  end

  def source_tracks
    source.file_tracks.to_a.concat source.shared_tracks.to_a
  end

end
