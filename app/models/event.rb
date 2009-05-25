class Event < ActiveRecord::Base

  public_resource_for :read, :index

  belongs_to :entry
  validates_presence_of :entry_id, :type

  def self.window_scope
    if 10.to_i > 0
      timestamp = Time.now.utc - 10.to_i.seconds
      lambda {|e| e.created_at > timestamp }
    end
  end
  export_scope :window

end
