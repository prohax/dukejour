class Library < ActiveRecord::Base
  include OSAHelpers

  public_resource

  has_many :tracks, :dependent => :destroy
  validates_presence_of :persistent_id, :name
  validates_uniqueness_of :persistent_id

  def self.import source
    puts "Importing library #{source.persistent_id} (#{source.name})."
    returning find_or_create_with({
      :persistent_id => source.persistent_id
    }, {
      :name => source.name
    }, true) do |library|
      count_before_import = library.tracks.count
      puts "Importing tracks from #{source.name} - already have #{count_before_import}."
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
