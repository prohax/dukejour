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
      unless Entry.next.nil?
        puts "Playing #{Entry.next.song.display_name}"
        Entry.next.play!
      end
    end
  end
end

def populate_thread
  start_thread 'populated', :sleep => 1 do
    populate
  end
end

namespace :dukejour do
  desc "run the backend services"
  task :backend => :environment do
    require 'appscript'
    include Appscript
    require 'i_tunes_interface'
    [
      discover, #is naturally asynchronous
      populate_thread,
      playback_thread
    ].each &:join
  end
end
