class AddImportedAtToLibraries < ActiveRecord::Migration
  def self.up
    add_column :libraries, :imported_at, :datetime
  end

  def self.down
    remove_column :libraries, :imported_at
  end
end
