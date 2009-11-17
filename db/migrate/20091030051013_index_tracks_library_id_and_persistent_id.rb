class IndexTracksLibraryIdAndPersistentId < ActiveRecord::Migration
  def self.up
    add_index :tracks, [:library_id, :persistent_id]
    add_index :tracks, [:persistent_id, :library_id]
  end

  def self.down
    remove_index :tracks, [:library_id, :persistent_id]
    remove_index :tracks, [:persistent_id, :library_id]
  end
end
