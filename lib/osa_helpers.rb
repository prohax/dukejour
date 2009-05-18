module OSAHelpers
  InvalidChars = %r{[^'"\sa-z0-9_-]}i
  
  def self.included base
    base.extend ClassMethods
    base.class_eval {
      OSA.utf8_strings = true
    }
  end

  module ClassMethods
    def iTunes
      @iTunes ||= OSA.app('iTunes')
    end

    def all_sources
      iTunes.sources.select {|s|
        [OSA::ITunes::ESRC::LIBRARY, OSA::ITunes::ESRC::SHARED_LIBRARY].include? s.kind
      }
    end
  end

end
