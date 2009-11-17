def start_thread name, opts = {}, &block
  opts[:sleep] ||= 1
  returning(Thread.new {
    loop do
      begin
        block.call
      rescue Exception => e
        puts "#{e.backtrace.first}: #{e.message}\n#{e.backtrace[1..6] * "\n"}"
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
        call_via_juggernaut :finished_event
      else
        Entry.next.tap {|entry|
          puts "Playing #{entry.song.display_name}"
          entry.play!
          call_via_juggernaut :play_event, entry.to_json(:include => :song)
        }
      end
    end
  end
end

def populate_thread
  start_thread 'populate', :sleep => 5 do
    populate
  end
end

def bonjour_thread
  start_thread 'bonjour', :sleep => 1 do
    run_bonjour
  end
end

namespace :dukejour do
  desc "run the backend services"
  task :backend => :environment do
    require 'appscript'
    include Appscript
    require 'i_tunes_interface'
    [
      populate_thread,
      playback_thread
    ].each &:join
  end
end
