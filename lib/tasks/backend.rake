require 'rubygems'

module Hammock
  module ActionController
    class Base
      def self.helper_method *args
      end
    end
    class Rescue
    end
    class Routing
      class RouteSet
        def draw
        end
      end
    end
    class Resources
      class Resource
      end
      def map_resource
      end
      def map_singleton_resource
      end
    end
  end
  module ActionView
    class Base
    end
  end
  class ApplicationController
  end
end

class Object
  MixInto = 'wat'
end

require 'vendor/plugins/hammock/lib/hammock'
include Hammock


require 'event'

require 'rbosa'
require 'i_tunes_interface'


def iTunes
  ITunesInterface.new
end

def start_thread name, &block
  returning(Thread.new &block) {
    puts "Started #{name} thread."
  }
end

def playback_thread
  start_thread 'playback' do
    loop do
      if iTunes.stopped?
        puts "playback looping."
        
        # 
        # ActiveRecord::Base.connection_pool.checkin ActiveRecord::Base.connection

        sleep 1
      end
    end
  end
end

def library_thread
  start_thread 'library' do
    loop do
      puts "library looping."

      sleep 1
    end
  end
end

namespace :dukejour do

  desc "run the backend services"
  task :backend do
    [
      playback_thread,
      library_thread
    ].each &:join
  end
end
