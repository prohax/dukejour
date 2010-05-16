def populate
  require 'appscript'
  include Appscript
  require 'delayed_job'
  require 'lib/i_tunes_interface'
  include ITunes

  (Library.all | iTunes.sources.map {|source|
    Library.create_for source
  }).each &:import!
end

namespace :dukejour do
  desc "populate the DB from the network"
  task :populate => :environment do
    populate
  end
end
