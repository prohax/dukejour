class VotesController < ApplicationController

  after_create "create event" do
    @vote.entry.vote_events.create
  end

end
