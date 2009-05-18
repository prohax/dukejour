class Entry < ActiveRecord::Base

  public_resource

  belongs_to :track
  delegate :play!, :to => :track

  named_scope :upcoming, :conditions => 'played_at IS NULL', :order => 'created_at DESC'

end
