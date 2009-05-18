namespace "dukejour" do
  desc "populate the DB from the network"
  task :populate => :environment do
    Library.all_sources.all? {|s|
      Library.import s
    }
  end
end
