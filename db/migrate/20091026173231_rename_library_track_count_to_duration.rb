class RenameLibraryTrackCountToDuration < ActiveRecord::Migration
  def self.up
    rename_column :libraries, :library_track_count, :duration
  end

  def self.down
    rename_column :libraries, :duration, :library_track_count
  end
end
