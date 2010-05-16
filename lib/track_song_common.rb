module TrackSongCommon
  def self.included base
    base.class_eval {
      field :artist
      field :album
      field :name
      field :year, :type => Integer
      field :duration, :type => Integer
      field :track_number, :type => Integer
      field :track_count, :type => Integer
      field :disc_number, :type => Integer
      field :disc_count, :type => Integer
    }
  end

  def has_artist?
    !artist.blank? && (/unknown( artist)?/i !~ artist)
  end

  def has_album?
    !album.blank? && (/unknown( album)?/i !~ album)
  end

  def has_year?
    !year.nil? && !year.zero?
  end

  def has_track_number?
    !track_number.nil? && !track_number.zero?
  end

end
