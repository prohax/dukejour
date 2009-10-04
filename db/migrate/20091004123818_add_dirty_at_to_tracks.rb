class AddDirtyAtToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :dirty_at, :datetime
  end

  def self.down
    remove_column :tracks, :dirty_at
  end
end
