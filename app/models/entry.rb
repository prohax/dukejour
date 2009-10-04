class Entry < ActiveRecord::Base

  public_resource_for :read, :create, :play, :vote

  belongs_to :track

  has_many :events, :dependent => :destroy
  has_many :add_events, :dependent => :destroy
  has_many :play_events, :dependent => :destroy
  has_many :vote_events, :dependent => :destroy

  def self.upcoming_scope
    L{|record| record.played_at.nil? }
  end

  def self.index_scope
    upcoming_scope
  end
  export_scope :index

  def self.sorter
    L{|record| -record.votes }
  end

  def self.upcoming
    select(&upcoming_scope).kick.sort_by(&sorter)
  end

  def self.next
    upcoming.first
  end

  def self.now_playing
    select {|record| !record.played_at.nil? }.sort_by {|record| -record.played_at }.first
  end

  def play!
    touch :played_at
    track.play!
  end

  def vote!
    offset! :votes, 1
    vote_events.create
  end

end
