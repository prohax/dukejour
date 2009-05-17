require 'rbosa'

module OSA

  def iTunes
    @iTunes ||= OSA.app('iTunes')
  end

  def libraries
    iTunes.sources.select {|s|
      s.kind == OSA::ITunes::ESRC::SHARED_LIBRARY
    }
  end

end
