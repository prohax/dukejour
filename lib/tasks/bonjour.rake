def bonjour
  require 'dnssd'
  
  require 'thread'
  require 'timeout'

  Thread.abort_on_exception = true
  mutex = Mutex.new
  
  DNSSD.browse('_daap._tcp.') do |br|
    begin
     Timeout.timeout(5) do
        DNSSD.resolve(br) do |rr|
          begin
            mutex.synchronize do
              puts br.name + if br.flags.add? then " joined." else " parted." end
              puts rr.text_record.map { |k,v| k + " => " + v }
              puts "\n" * 3
              # rr_exists = Proc.new {|existing_rr| existing_rr.target == rr.target && existing_rr.fullname == rr.fullname}
              # if (DNSSD::Flags::Add & br.flags.to_i) != 0
                # @replies << rr unless @replies.any?(&rr_exists)
              # else
                # @replies.delete_if(&rr_exists)
              # end
            end
          rescue DNSSD::UnknownError
            $stderr.puts "unknown error occurred in dnssd: #{$!.message}"
          ensure
            rr.service.stop unless rr.service.stopped?
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
    # sleep 10
    sleep 0.1 while true
  end
end
  
