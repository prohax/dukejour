class Vote < ActiveRecord::Base

  public_resource_for :read, :index, :create

  belongs_to :entry

  validates_presence_of :entry_id

end
