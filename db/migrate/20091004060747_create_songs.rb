class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs, :force => true do |t|
      t.string :artist, :limit => 256
      t.string :album, :limit => 256
      t.string :name, :limit => 256

      t.integer :year
      t.integer :duration

      t.timestamps
    end

    add_column :tracks, :song_id, :integer
  end

  def self.down
    remove_column :tracks, :song_id
    drop_table :songs
  end
end
