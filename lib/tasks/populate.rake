def populate
  require 'appscript'
  include Appscript
  require 'delayed_job'

  (Library.all | iTunes.sources.map {|source|
    Library.create_for source
  }).each &:import
end

namespace :dukejour do
  desc "populate the DB from the network"
  task :populate => :environment do
    populate
  end
end
