class User < ActiveRecord::Base

  has_many :events, :foreign_key => 'creator_id', :dependent => :destroy
  has_many :add_events
  has_many :vote_events

end
