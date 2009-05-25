class VotesController < ApplicationController

  after_create "create vote event" do
    @vote.entry.vote_events.create
  end

end
