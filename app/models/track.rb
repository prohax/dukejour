class Track
  include Mongoid::Document
  include HammockMongo
  include TrackSongCommon

  embedded_in :song, :inverse_of => :tracks
  belongs_to_related :library
  field :persistent_id
  field :dirty_at, :type => Time
  field :bit_rate, :type => Integer
  field :kind

  def clean_strings
    artist.strip! unless artist.nil?
    album.strip! unless album.nil?
    name.strip! unless name.nil?
  end

  def self.import! track_source, library
    Song.add_track! new_for(track_source, library)
  end

  def self.new_for track_source, library
    new(
      :library => library,

      :persistent_id => track_source['persistent_ID'],
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
    )
  end

  def source
    library_source = library.source
    library_source.search(:for => name.normalize).detect {|t|
      t.persistent_ID.get == persistent_id
    } unless library_source.nil?
  end

  def quality
    # Consider some bitrates to be "better" than others - e.g. 128kbps AAC ~ 192kbps MP3.
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
