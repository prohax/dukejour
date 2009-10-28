class AddTracksSongIdIndex < ActiveRecord::Migration
  def self.up
    add_index :tracks, :song_id
  end

  def self.down
    remove_index :tracks, :song_id
  end
end
