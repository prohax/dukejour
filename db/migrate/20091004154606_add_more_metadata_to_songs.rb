class AddMoreMetadataToSongs < ActiveRecord::Migration
  def self.up
    add_column :songs, :track_number, :integer
    add_column :songs, :track_count, :integer
    add_column :songs, :disc_number, :integer
    add_column :songs, :disc_count, :integer
  end

  def self.down
    remove_column :songs, :disc_count
    remove_column :songs, :disc_number
    remove_column :songs, :track_count
    remove_column :songs, :track_number
  end
end
