class AddLibraryTrackCountToLibraries < ActiveRecord::Migration
  def self.up
    add_column :libraries, :library_track_count, :integer
  end

  def self.down
    remove_column :libraries, :library_track_count
  end
end
