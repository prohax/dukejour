class ApplicationController < ActionController::Base
  include Hammock::RestfulActions

  helper :all
  layout 'application'
  protect_from_forgery

  after_filter :log_hit

  private

  def current_user
    nil
  end

  def call_via_juggernaut function, data
    Juggernaut.send_to_channels "#{function}(#{escape_juggernaut data});", ['dukejour']
  end

  def escape_juggernaut message
    message.gsub(/\n/, '\n').gsub(/\r/, '\r')
  end
end
