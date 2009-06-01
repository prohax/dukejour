RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'hammock', :version => '~> 0.3.0'
  config.gem 'haml'
  config.gem 'rubyosa', :lib => 'rbosa'

  config.time_zone = 'UTC'
end

def iTunes
  ITunesInterface.new
end
