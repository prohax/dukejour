class IndexSongsSearchArtistSearchNameAndDuration < ActiveRecord::Migration
  def self.up
    add_index :songs, [:search_artist, :search_name, :duration]
    add_index :songs, [:search_name, :search_artist, :duration]
  end

  def self.down
    remove_index :songs, [:search_artist, :search_name, :duration]
    remove_index :songs, [:search_name, :search_artist, :duration]
  end
end
