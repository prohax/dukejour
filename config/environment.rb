RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'hammock', :version => '~> 0.3.9'
  config.gem 'haml'

  config.time_zone = 'UTC'
end

if "irb" == $0
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  require 'hirb'
  Hirb.enable
  
  require 'rbosa'
end

def iTunes
  ITunesInterface.new
end
