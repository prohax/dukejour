class ITunesInterface

  def sources
    app_reference.sources.select {|s|
      [OSA::ITunes::ESRC::LIBRARY, OSA::ITunes::ESRC::SHARED_LIBRARY].include? s.kind
    }
  rescue
    puts "Couldn't connect to iTunes."
    []
  end

  def player_state
    case app_reference.player_state
    when OSA::ITunes::EPLS::STOPPED; :stopped
    when OSA::ITunes::EPLS::PLAYING; :playing
    when OSA::ITunes::EPLS::PAUSED;  :paused
    end
  end

  def stopped?; :stopped == player_state end
  def playing?; :playing == player_state end
  def paused?;  :paused  == player_state end

  def play! obj = nil
    if obj
      app_reference.play obj, :once => true
    elsif paused?
      app_reference.playpause
    end
  end
  def pause!
    app_reference.pause
  end
  def stop!
    app_reference.stop
  end

  private

  def app_reference
    OSA.utf8_strings = true
    @app_reference ||= OSA.app('iTunes')
  end

end