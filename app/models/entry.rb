class Entry < ActiveRecord::Base
  belongs_to :song

  has_many :events, :dependent => :destroy
  has_many :add_events
  has_many :vote_events

  validates_uniqueness_of :song_id, :scope => :played_at, :message => "That song is already queued."

  # has_defaults :votes => 1

  before_create :default_votes_to_one
  def default_votes_to_one
    self.votes ||= 1
  end

  delegate :active?, :to => :song

  default_scope :conditions => {:played_at => nil}

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
    where(:played_at => nil).order('played_at DESC').first
  end

  def play!
    touch :played_at
    song.play!
  end

  def vote! opts
    if (event = events.find_by_creator_id(opts[:creator].id)).nil?
      offset! :votes, 1 if vote_events.create :creator => opts[:creator]
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
