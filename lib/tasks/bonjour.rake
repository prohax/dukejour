def bonjour
  require 'dnssd'
  
  require 'thread'
  require 'timeout'

  Thread.abort_on_exception = true
  mutex = Mutex.new
  
  DNSSD.browse('_daap._tcp.') do |br|
    begin
      if !br.flags.add?
        puts br.name + " dropped. Nothing to do."
      else
        puts br.name + " detected."
        Timeout.timeout(5) do
          DNSSD.resolve(br) do |rr|
            begin
              mutex.synchronize do
                if rr.text_record["Password"] != "0"
                  puts "Can't import, this library is password-protected."
                  break
                else
                  discover [rr.text_record["Machine Name"]]
                end
              end
            rescue DNSSD::UnknownError
              $stderr.puts "unknown error occurred in dnssd: #{$!.message}"
            ensure
              rr.service.stop unless rr.service.stopped?
            end
          end
        end
      end
    rescue DNSSD::UnknownError
      $stderr.puts "unknown error occurred in dnssd: #{$!.message}"
    rescue Timeout::Error
      # Do nothing
    end
  end
end

namespace :dukejour do
  desc "find the libraries over bonjour"
  task :bonjour do
    bonjour
    sleep 10 while true
  end
end
  
