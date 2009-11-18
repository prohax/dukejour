class AddCreatorIdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :creator_id, :integer
  end

  def self.down
    remove_column :events, :creator_id
  end
end
