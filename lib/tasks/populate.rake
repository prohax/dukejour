namespace "dukejour" do
  desc "populate the DB from the network"
  task :populate => :environment do
    (Library.all | iTunes.sources.map {|source|
      Library.create_for source
    }).each &:import
  end
end
