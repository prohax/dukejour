namespace "dukejour" do
  desc "make iTunes discover and connect to all shared libraries"
  task :discover do
    require 'rbosa'
    itunes = OSA.app('iTunes')
    itunes.activate
  
    sys = OSA.app("System Events")
    process = sys.processes.find { |p| p.name == "iTunes" }

    rows = process.windows[0].splitter_groups[0].scroll_areas[0].outlines[0].rows
    row_names = rows.map { |r| r.static_texts[0].name }
    shared_index = row_names.index("SHARED")
    if shared_index.nil?
      puts "No shared libraries available!"
    else
      ((shared_index + 1)..(row_names.index("PLAYLISTS") - 1)).each { |r_index|
        puts "Adding library #{row_names[r_index]}"
        rows[r_index].actions.select { |a| a.name == "AXShowMenu" }.first.perform
        sleep(1)
        sys.key_code 53 # escape the right-click menu
        sleep(1)
        sys.key_code 53 # escape the password prompt, if it appeared
        sys.key_code 100 # dismiss an error dialog, e.g. 'too many connections', if it appeared
        sleep(1)
        puts "Done."
      }
    end
  end
end
