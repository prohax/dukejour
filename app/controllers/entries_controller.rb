class EntriesController < ApplicationController

  after_create "create add event" do
    @entry.add_events.create
  end

  def play
    @entry.track.play! if find_record
    render :nothing => true
  end

  def vote
    @entry.vote! if find_record
    render :nothing => true
  end

end
