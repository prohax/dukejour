class EntriesController < ApplicationController

  before_index "load libraries" do
    @libraries = Library.all
  end
  after_create "load libraries" do
    @libraries = Library.all
  end

  after_create "create add event" do
    @entry.add_events.create :creator => current_user
  end

  after_create "juggernaut render" do
    respond_to {|format|
      format.jug { render_juggernaut :add_event, render(:partial => 'index_entry.html', :locals => {:entry => @entry}).inspect }
    }
  end

  def vote
    if find_record
      if @entry.vote! :creator => current_user
        respond_to {|format|
          format.jug { render_juggernaut :vote_event, @entry.to_json(:include => :song) }
        }
      end
    end
  end

end
