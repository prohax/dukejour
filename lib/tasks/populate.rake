namespace "dukejour" do
  desc "populate the DB from the network"
  task :populate => :environment do
    iTunes.sources.each {|source|
      Library.create_for source
    }
    Library.each &:import
  end
end
