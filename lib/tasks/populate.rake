namespace "dukejour" do
  desc "populate the DB from the network"
  task :populate => :environment do
    iTunes.sources.all? {|s|
      Library.import s
    }
  end
end
