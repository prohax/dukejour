class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :track_id

      t.datetime :played_at

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
