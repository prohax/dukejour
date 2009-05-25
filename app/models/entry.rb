class Entry < ActiveRecord::Base

  public_resource_for :read, :index

  belongs_to :track

  has_many :votes

  has_many :events
  has_many :add_events
  has_many :play_events
  has_many :vote_events

  delegate :play!, :to => :track

  named_scope :upcoming, :conditions => 'played_at IS NULL', :order => 'created_at DESC'

end
