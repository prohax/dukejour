module JuggernautHelpers
  def self.call_via_juggernaut function, data = "{}"
    # Juggernaut not working at all :(
    puts "JUGGERNAUT: #{function}(#{escape_juggernaut data});"
#    Juggernaut.send_to_channels "#{function}(#{escape_juggernaut data});", ['dukejour']
  end

  def self.escape_juggernaut message
    message.gsub(/\n/, '\n').gsub(/\r/, '\r')
  end

  def self.juggernaut_message message, opts = {}
    call_via_juggernaut :message_event, opts.merge({
      :message => message,
      :timestamp => Time.now.to_i_msec
    }).to_json
  end
end
