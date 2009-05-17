class Library < ActiveRecord::Base
  extend OSA

  has_many :tracks
  public_resource

  def self.all_osa
    libraries
  end

  def osa_tracks
    libraries.detect {|l|
      l.id2 == id2
    }.library_playlists[0].shared_tracks
  end

end
