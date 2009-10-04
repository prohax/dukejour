def start_thread name, opts = {}, &block
  opts[:sleep] ||= 1
  returning(Thread.new {
    loop do
      begin
        block.call
      rescue Exception => e
        puts "#{e.backtrace.first}: #{e.message}"
      ensure
        ActiveRecord::Base.connection_pool.checkin ActiveRecord::Base.connection
      end
      sleep opts[:sleep]
    end
  }) {
    puts "Started #{name} thread, firing every #{opts[:sleep]}s."
  }
end

def playback_thread
  start_thread 'playback' do
    if iTunes.stopped?
      if Entry.next.nil?
        # Nothing to play next.
      else
        puts "Playing #{Entry.next.track.persistent_id} / #{Entry.next.track.artist} - #{Entry.next.track.name}"
        Entry.next.play!
      end
    end
  end
end

def populate_thread
  start_thread 'library', :sleep => 10 do
    populate
  end
end

def discover_thread
  start_thread 'library', :sleep => 30 do
    discover
  end
end

namespace :dukejour do
  desc "run the backend services"
  task :backend => :environment do
    require 'rbosa'
    require 'i_tunes_interface'
    [
      playback_thread,
      populate_thread,
      discover_thread
    ].each &:join
  end
end
