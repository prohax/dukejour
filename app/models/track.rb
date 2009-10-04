class Track < ActiveRecord::Base

  include TrackSongCommon

  belongs_to :library
  validates_presence_of :persistent_id, :library_id
  validates_uniqueness_of :persistent_id, :scope => :library_id

  belongs_to :song

  before_create :clean_strings
  after_create :update_song

  def clean_strings
    artist.strip! unless artist.nil?
    album.strip! unless album.nil?
    name.strip! unless name.nil?
  end
  
  def update_song
    song.update_metadata
  end

  def self.import track_source, library
    returning find_or_create_with({
      :persistent_id => track_source.persistent_id,
      :library_id => library.id,
      :song_id => Song.for(track_source).id
    }, {
      :artist => track_source.artist,
      :album => track_source.album,
      :name => track_source.name,
      :year => track_source.year,
      :duration => (track_source.duration || -1)
    }, true) do |track|
      if track.new_or_deleted_before_save?
        puts "Added #{library.name}/#{track_source.persistent_id}: #{track_source.name}"
      end
    end
  end

  def self.persistent_ids_for library
    ActiveRecord::Base.connection.execute(
      "SELECT persistent_id FROM tracks WHERE library_id = #{library.id}"
    ).map {|i|
      i['persistent_id']
    }
  end

  def source
    library_source = library.source
    library_source.search(name.normalize).detect {|t|
      t.persistent_id == persistent_id
    } unless library_source.nil?
  end

  def play!
    iTunes.play source
  end

end
