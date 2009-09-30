class Entry < ActiveRecord::Base

  public_resource_for :read, :index, :create, :play

  belongs_to :track

  has_many :votes, :dependent => :destroy

  has_many :events, :dependent => :destroy
  has_many :add_events, :dependent => :destroy
  has_many :play_events, :dependent => :destroy
  has_many :vote_events, :dependent => :destroy

  delegate :play!, :to => :track

  named_scope :upcoming, :conditions => 'played_at IS NULL', :order => 'created_at DESC'

end
