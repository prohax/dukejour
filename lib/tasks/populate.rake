namespace "dukejour" do
  desc "populate the DB from the network"
  task :populate => :environment do
    Library.delete_all
    Track.delete_all

    Library.all_osa.each {|l|
      l.library_playlists[0].shared_tracks.each {|t|
        puts "Adding #{t.name} from #{t.artist} from #{l.name}"
        $db.execute("INSERT INTO tracks VALUES (null, '#{l.name}', '#{t.artist}', '#{t.name}')")
      }
    }
  end
end
