class ITunesInterface

  def sources
    app_reference.sources.get.select {|s|
      [:library, :shared_library].include? s.kind.get
    }
  rescue Exception => ex
    puts "#{ex.class}: Couldn't connect to iTunes: #{ex.backtrace.first}: #{ex.message}"
    []
  end

  def player_state
    app_reference.player_state.get
  end

  def stopped?; :stopped == player_state end
  def playing?; :playing == player_state end
  def paused?;  :paused  == player_state end

  def play! obj = nil
    if obj
      app_reference.play obj, :once => true, :timeout => 5
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
    @app_reference ||= Appscript.app('iTunes')
  end

end