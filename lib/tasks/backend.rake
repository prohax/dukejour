def play_next
  require 'lib/i_tunes_interface'
  include ITunes

  if iTunes.stopped?
    if Entry.next.nil?
      # Juggernaut still borked
      JuggernautHelpers.call_via_juggernaut :finished_event
    else
      Entry.next.tap {|entry|
        puts "Playing #{entry.song.display_name}"
        entry.play!
        # Juggernaut still borked
        JuggernautHelpers.call_via_juggernaut :play_event, entry.to_json(:include => :song)
      }
    end
  end
end

def loop_task name, opts, &block
  require 'appscript'
  include Appscript
  STDOUT.sync = true

  puts "#{Process.pid}: starting #{name}, firing every #{opts[:sleep]} seconds."
  loop {
    begin
      sleep opts[:sleep]
      block.call
    rescue Exception => e
      puts "#{e.backtrace.first}: #{e.message}\n#{e.backtrace[1..6] * "\n"}"
      raise e
    ensure
      ActiveRecord::Base.connection_pool.checkin ActiveRecord::Base.connection
    end
  }
end

def fork_off cmd, index
  require 'active_support/core_ext'
  require 'open3'
  # colors = %w[blue green yellow pink cyan]

  returning(Thread.new {
    loop {
      Open3.popen3(cmd + " 2>> log/errors.log") { |i,o,e|
        print o.gets until o.eof?
      }
    }
  }) {
    puts "Forked off #{cmd.inspect}."
  }
end

namespace :dukejour do
  task :playback_loop => :environment do
    loop_task "playback", :sleep => 1 do
      play_next
    end
  end

  task :populate_loop => :environment do
    loop_task "populate", :sleep => 5 do
      populate
    end
  end

  task :jobs => :environment do
    require 'appscript'
    include Appscript
    require 'delayed_job'

    Delayed::Worker.new(:min_priority => ENV['MIN_PRIORITY'], :max_priority => ENV['MAX_PRIORITY']).start
  end

  tasks = [
    "juggernaut -c config/juggernaut.yml -l log/juggernaut.log",
    "rake dukejour:populate_loop",
    "rake dukejour:playback_loop",
    "rake dukejour:bonjour",
    "rake dukejour:jobs"
  ]

  task :backend do
    tasks.zip((1..tasks.length).to_a).map {|cmd,i|
      fork_off(cmd, i)
    }.each &:join
  end
end
