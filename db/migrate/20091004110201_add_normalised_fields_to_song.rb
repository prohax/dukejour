class AddNormalisedFieldsToSong < ActiveRecord::Migration
  def self.up
    add_column :songs, :normalized_artist, :string
    add_column :songs, :normalized_album, :string
    add_column :songs, :normalized_name, :string
  end

  def self.down
    remove_column :songs, :normalized_name
    remove_column :songs, :normalized_album
    remove_column :songs, :normalized_artist
  end
end
