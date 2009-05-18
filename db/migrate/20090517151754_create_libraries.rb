class CreateLibraries < ActiveRecord::Migration
  def self.up
    create_table :libraries do |t|
      t.string :persistent_id, :limit => 16

      t.string :name, :limit => 256

      t.timestamps
    end
  end

  def self.down
    drop_table :libraries
  end
end
