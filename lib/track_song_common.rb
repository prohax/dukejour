module TrackSongCommon

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
