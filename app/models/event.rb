class Event < ActiveRecord::Base

  public_resource_for :read, :index

  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'
  belongs_to :entry
  validates_presence_of :creator_id, :entry_id, :type
end
