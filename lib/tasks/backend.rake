def iTunes
  ITunesInterface.new
end

def start_thread name, &block
  returning(Thread.new {
    loop do
      puts "#{name} looping."
      begin
        block.call
      rescue Exception => e
        puts "#{e.backtrace.first}: #{e.message}"
      ensure
        ActiveRecord::Base.connection_pool.checkin ActiveRecord::Base.connection
      end
      sleep 1
    end
  }) {
    puts "Started #{name} thread."
  }
end

def playback_thread
  start_thread 'playback' do
    if iTunes.stopped?
      if Entry.next.nil?
        puts "Nothing to play next."
      else
        puts "Playing #{Entry.next.track.persistent_id} / #{Entry.next.track.artist} - #{Entry.next.track.name}"
        Entry.next.play!
      end
    end
  end
end

def library_thread
  start_thread 'library' do
  end
end

namespace :dukejour do
  desc "run the backend services"
  task :backend => :environment do
    require 'rbosa'
    require 'i_tunes_interface'
    [
      playback_thread,
      library_thread
    ].each &:join
  end
end
