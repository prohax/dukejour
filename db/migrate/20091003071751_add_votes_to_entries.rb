class AddVotesToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :votes, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :entries, :votes
  end
end
