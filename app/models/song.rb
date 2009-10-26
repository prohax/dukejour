class Song < ActiveRecord::Base

  include TrackSongCommon

  public_resource_for :read, :index

  has_many :tracks
  has_many :libraries, :through => :tracks

  before_save :set_normalized_fields

  def set_normalized_fields
    self.normalized_name   =   name.normalize_for_display unless name.nil?
    self.normalized_album  =  album.normalize_for_display unless album.nil?
    self.normalized_artist = artist.normalize_for_display unless artist.nil?
  end

  def self.suggestable
    ambition_context.within(Library.select {|l| l.active }, :libraries)
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

  def self.for track_source
    track_search_artist = to_search_field(track_source.artist.get)
    track_search_name = to_search_field(track_source.name.get)
    track_duration = case (d = track_source.duration.get)
      when Symbol: -1
      else d.round
    end            
    select {|song|
      song.duration >= track_duration - 3 &&
      song.duration <= track_duration + 3
    }.find(:all, :conditions => {
      :search_artist => track_search_artist,
      :search_name => track_search_name
    }).first || Song.create(
      :search_artist => track_search_artist,
      :search_name => track_search_name,
      :duration => track_duration
    )
  end

  def update_metadata
    unless tracks.length.zero? # empty? would do a count(*), then tracks would be a second query.
      adjust Hash[*metadata_cols.zip(tracks.map {|t|
        metadata_cols.map {|c| t.send c }
      }.transpose).map {|col,data|
        [col, data.compact.hash_by(:self, &:length).sort_by {|_,v| -v }.first.first]
      }.flatten]
    end
  end


  private

  def metadata_cols
    [:artist, :album, :name, :year, :duration, :track_number, :track_count, :disc_number, :disc_count]
  end

  def self.to_search_field field
    field.downcase.gsub(/\b(the|a|an|and)\b/, '').normalize_for_display.gsub(/\W/, '').to_s
  end

end
