class RemoveVotesTable < ActiveRecord::Migration
  def self.up
    drop_table :votes
  end

  def self.down
    create_table "votes", :force => true do |t|
      t.integer  "entry_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
