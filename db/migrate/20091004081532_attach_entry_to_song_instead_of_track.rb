class AttachEntryToSongInsteadOfTrack < ActiveRecord::Migration
  def self.up
    rename_column :entries, :track_id, :song_id
  end

  def self.down
    rename_column :entries, :song_id, :track_id
  end
end
