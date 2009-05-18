class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.integer :library_id

      t.string :persistent_id, :limit => 16

      t.string :artist, :limit => 256
      t.string :album, :limit => 256
      t.string :name, :limit => 256
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
