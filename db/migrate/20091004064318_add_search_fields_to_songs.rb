class AddSearchFieldsToSongs < ActiveRecord::Migration
  def self.up
    add_column :songs, :search_artist, :string
    add_column :songs, :search_name, :string
  end

  def self.down
    remove_column :songs, :search_name
    remove_column :songs, :search_artist
  end
end
