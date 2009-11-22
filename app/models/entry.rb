class Entry < ActiveRecord::Base

  public_resource_for :read, :create, :play, :vote

  belongs_to :song

  has_many :events, :dependent => :destroy
  has_many :add_events
  has_many :vote_events

  validates_uniqueness_of :song_id, :scope => :played_at, :message => "That song is already queued."

  has_defaults :votes => 1

  delegate :active?, :to => :song

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
    if (event = events.find_by_creator_id(opts[:creator].id)).nil?
      offset! :votes, 1
    else
      if event.is_a? AddEvent
        errors.add :You, "can't vote for songs that you added."
      else
        errors.add :You, "can't vote for the same track twice."
      end
      nil
    end
  end

end
