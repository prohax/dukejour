class Event < ActiveRecord::Base

  public_resource_for :read, :index

  belongs_to :entry
  validates_presence_of :entry_id, :type

  def self.window_scope
    timestamp = Time.now.utc - 2.seconds
    L{|e| e.created_at > timestamp }
  end
  export_scope :window

end
