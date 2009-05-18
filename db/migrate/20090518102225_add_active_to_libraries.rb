class AddActiveToLibraries < ActiveRecord::Migration
  def self.up
    add_column :libraries, :active, :boolean
  end

  def self.down
    remove_column :libraries, :active
  end
end
