RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'hammock', :version => '~> 0.5.3'
  config.gem 'haml'

  config.time_zone = 'UTC'
end

if "irb" == $0
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  require 'hirb'
  Hirb.enable
  
  require 'appscript'
  include Appscript
end

def iTunes
  ITunesInterface.new
end

def call_via_juggernaut function, data = "{}"
  Juggernaut.send_to_channels "#{function}(#{escape_juggernaut data});", ['dukejour']
end

def escape_juggernaut message
  message.gsub(/\n/, '\n').gsub(/\r/, '\r')
end
