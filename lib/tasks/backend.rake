def play_next
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

def loop_task name, opts, &block
  require 'appscript'
  include Appscript
  require 'i_tunes_interface'
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

def fork_off cmd
  require 'open3'
  returning(Thread.new {
    loop {
      Open3.popen3(cmd + " 2>> log/errors.log") { |i,o,e|
        puts "popen3(#{cmd.inspect})"
        puts o.gets until o.eof?
        puts 'eof'
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

  task :backend do
    [
      fork_off("rake dukejour:populate_loop"),
      fork_off("rake dukejour:playback_loop")
    ].each &:join
  end
end
