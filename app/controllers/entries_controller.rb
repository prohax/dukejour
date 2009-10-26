class EntriesController < ApplicationController

  after_create "create add event" do
    @entry.add_events.create
    call_via_juggernaut :add_event, render(:partial => 'index_entry', :locals => {:entry => @entry}).inspect
  end

  def vote
    @entry.vote! if find_record
    call_via_juggernaut :vote_event, @entry.to_json(:include => :song)
    render :nothing => true
  end

end
