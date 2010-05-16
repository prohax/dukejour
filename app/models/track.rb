class Track
  include Mongoid::Document
  include HammockMongo
  include TrackSongCommon

  field :persistent_id
  field :dirty_at, :type => Time
  field :bit_rate, :type => Integer
  field :kind
  embedded_in :library, :inverse_of => :tracks
  embedded_in :song, :inverse_of => :tracks

  validates_presence_of :persistent_id, :library
  validates_uniqueness_of :persistent_id, :scope => :library

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
      :library => library
    }, {
      :song => Song.for(track_source),

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
      puts "#{track.new_or_deleted_before_save? ? 'Added' : 'Updated'} #{library.name}/#{track.persistent_id}: #{track.name}"
    end
  end

  def self.clean_persistent_ids_for library
    library.tracks.only(:persistent_id).where(:dirty_at => nil)
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
