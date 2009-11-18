class Entry < ActiveRecord::Base

  public_resource_for :read, :create, :play

  belongs_to :song

  has_many :events, :dependent => :destroy
  has_many :add_events
  has_many :vote_events

  has_defaults :votes => 1

  delegate :active?, :to => :song

  def self.vote_scope_for user
    entry_ids = user.events.find(:all, :select => 'events.entry_id').map(&:entry_id).push(0)
    L{|record| !entry_ids.include?(record.id) }
  end
  export_scope :vote

  def self.upcoming_scope
    L{|record| record.played_at.nil? }
  end

  def self.index_scope
    upcoming_scope
  end
  export_scope :index

  def self.sorter
    L{|record| [-record.votes, record.created_at] }
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
    song.play!
  end

  def vote! opts
    offset! :votes, 1 if vote_events.create(opts).valid?
  end

end
