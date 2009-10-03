class Object
  MixInto = 'wat'
end

module RailsStubs
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
end

def require_and_include
  require 'vendor/plugins/hammock/lib/hammock'
  include Hammock

  require 'entry'
  require 'track'
  require 'library'

  require 'rbosa'
  require 'i_tunes_interface'
end

def init_for_backend
  require 'rubygems'
  include RailsStubs
  require_and_include

  Rails::Initializer.new(Rails::Configuration.new).initialize_database
end




def iTunes
  ITunesInterface.new
end

def start_thread name, &block
  returning(Thread.new {
    loop do
      puts "#{name} looping."
      begin
        block.call
      rescue Exception => e
        puts "#{e.backtrace.first}: #{e.message}"
      ensure
        ActiveRecord::Base.connection_pool.checkin ActiveRecord::Base.connection
      end
      sleep 1
    end
  }) {
    puts "Started #{name} thread."
  }
end

def playback_thread
  start_thread 'playback' do
    if iTunes.stopped?
      next_track = Entry.upcoming.first
      if next_track.nil?
        puts "Nothing to play next."
      else
        puts "Playing #{next_track.track.persistent_id} / #{next_track.track.artist} - #{next_track.track.name}"
        next_track.play!
      end
    end
  end
end

def library_thread
  start_thread 'library' do
  end
end

namespace :dukejour do

  desc "run the backend services"
  task :backend do
    init_for_backend
    [
      playback_thread,
      library_thread
    ].each &:join
  end
end
