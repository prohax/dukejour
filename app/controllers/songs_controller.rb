class SongsController < ApplicationController

  before_suggest 'set order' do
    @order = %w[songs.normalized_artist songs.normalized_album songs.disc_number songs.track_number songs.normalized_name]
  end

end
