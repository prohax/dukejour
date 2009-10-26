class Event < ActiveRecord::Base

  public_resource_for :read, :index

  belongs_to :entry
  validates_presence_of :entry_id, :type

end
