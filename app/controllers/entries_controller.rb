class EntriesController < ApplicationController

  after_create "create add event" do
    @entry.add_events.create
  end

end
