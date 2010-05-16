class Track < ActiveRecord::Base
  include Mongoid::Document
  embedded_in :library, :inverse_of => :tracks


  include TrackSongCommon

  validates_presence_of :persistent_id, :library_id
  validates_uniqueness_of :persistent_id, :scope => :library_id

  belongs_to :song

  before_save :clean_strings
  after_save :update_song

  named_scope :dirty, :conditions => "dirty_at IS NOT NULL"

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
      :persistent_id => track_source['persistent_ID'],
      :library_id => library.id
    }, {
      :song_id => Song.for(track_source).id,

      :artist => track_source['artist'],
      :album => track_source['album'],
      :name => track_source['name'],
      :year => track_source['year'],
      :duration => (track_source['duration'] || -1),
      :track_number => track_source['track_number'],
      :track_count => track_source['track_count'],
      :disc_number => track_source['disc_number'],
      :disc_count => track_source['disc_count'],
      :bit_rate => track_source['bit_rate'],
      :kind => kind_for(track_source['kind']),

      :dirty_at => nil
    }, true) do |track|
      puts "#{track.new_or_deleted_before_save? ? 'Added' : 'Updated'} #{library.name}/#{track_source['persistent_ID']}: #{track_source['name']}"
    end
  end

  def self.clean_persistent_ids_for library
    ActiveRecord::Base.connection.execute(
      "SELECT persistent_id FROM tracks WHERE library_id = #{library.id} AND dirty_at IS NULL"
    ).map {|i|
      i['persistent_id']
    }
  end

  def source
    library_source = library.source
    library_source.search(:for => name.normalize).detect {|t|
      t.persistent_ID.get == persistent_id
    } unless library_source.nil?
  end

  def quality
    # Consider some bitrates to be "better" than others - e.g. 192kbps AAC ~ 192kbps MP3.
    bit_rate * ({
      'AAC' => 1.4
    }[kind] || 1)
  end

  def play!
    iTunes.play! source
  end

  def self.kind_for kind_str
    if kind_str['AAC audio file']
      'AAC'
    elsif kind_str['Apple Lossless audio file']
      'Apple Lossless'
    elsif kind_str['MPEG audio file']
      'MP3'
    else
      'unknown'
    end
  end
end
