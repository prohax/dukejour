# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Rails3::Application.initialize!

if "irb" == $0
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  require 'hirb'
  Hirb.enable

  require 'appscript'
  include Appscript
end
