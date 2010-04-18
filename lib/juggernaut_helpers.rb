module JuggernautHelpers
  def call_via_juggernaut function, data = "{}"
    Juggernaut.send_to_channels "#{function}(#{escape_juggernaut data});", ['dukejour']
  end

  def escape_juggernaut message
    message.gsub(/\n/, '\n').gsub(/\r/, '\r')
  end

  def juggernaut_message message, opts = {}
    call_via_juggernaut :message_event, opts.merge({
      :message => message,
      :timestamp => Time.now.to_i_msec
    }).to_json
  end
end
