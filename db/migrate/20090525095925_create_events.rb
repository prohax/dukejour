class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|

      t.integer :entry_id

      t.string :type, :limit => 16

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
