class AddMoreMetadataToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :track_number, :integer
    add_column :tracks, :track_count, :integer
    add_column :tracks, :disc_number, :integer
    add_column :tracks, :disc_count, :integer

    add_column :tracks, :bit_rate, :integer
    add_column :tracks, :kind, :string, :limit => 16
  end

  def self.down
    remove_column :tracks, :kind
    remove_column :tracks, :bit_rate

    remove_column :tracks, :disc_count
    remove_column :tracks, :disc_number
    remove_column :tracks, :track_count
    remove_column :tracks, :track_number
  end
end
