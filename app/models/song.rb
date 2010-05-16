class Song
  include Mongoid::Document
  include HammockMongo
  include TrackSongCommon

  embeds_many :tracks
  field :search_artist
  field :search_name
  field :normalized_artist
  field :normalized_album
  field :normalized_name

  before_save :set_normalized_fields
  before_save :update_metadata

  def set_normalized_fields
    self.normalized_name   =   name.normalize_for_display unless name.nil?
    self.normalized_album  =  album.normalize_for_display unless album.nil?
    self.normalized_artist = artist.normalize_for_display unless artist.nil?
  end

  def self.active
    where('tracks.library.active' => true)
  end

  def active?
    self.class.active.where(:id => id).first
  end

  def self.suggestable
    active
  end

  def display_name
    "#{artist} [#{album}] - #{track_number} #{name}"
  end

  def best_track
    tracks.sort_by(&:quality).reverse.detect {|t|
      returning !t.source.nil? do |result|
        puts "Source for #{t.persistent_id} (from #{t.library.name}) #{result ? 'present' : 'missing'}."
      end
    }
  end

  def play!
    returning best_track do |track|
      if track.nil?
        puts "Couldn't play #{display_name} - no available tracks."
      else
        track.play!
      end
    end
  end

  def self.add_track! track
    song = self.for(track)
    song.tracks.delete_if {|t| t.persistent_id == track.persistent_id }
    song.tracks << track
    returning song.save do |result|
      puts "Added Track<#{track.persistent_id}> to #{song.name}: #{result}."
    end
  end

  def self.for track
    track_search_artist = to_search_field(track.artist)
    track_search_name = to_search_field(track.name)

    Song.where(
      :duration.lte => (track.duration + 3),
      :duration.gte => (track.duration - 3),
      :search_artist => track_search_artist,
      :search_name => track_search_name
    ).first || Song.new(
      :search_artist => track_search_artist,
      :search_name => track_search_name,
      :duration => track.duration
    )
  end

  def update_metadata
    self.attributes = metadata_cols.inject({}) { |hash, col|
      track_metadatas = tracks.map { |t| t.send col }.compact
      if !track_metadatas.empty?
        most_common_metadata = track_metadatas.hash_by(:self, &:length).sort_by {|_, v| -v }.first.first
        hash[col] = most_common_metadata
      end
      hash
    }
  end


  private

  def metadata_cols
    [:artist, :album, :name, :year, :duration, :track_number, :track_count, :disc_number, :disc_count]
  end

  def self.to_search_field field
    field.downcase.gsub(/\b(the|a|an|and)\b/, '').normalize_for_display.gsub(/\W/, '').to_s
  end

end
