def discover
  require 'appscript'
  include Appscript
  
  itunes = app('iTunes')

  sys = app('System Events')
  process = sys.processes.get.find { |p| p.name.get == "iTunes" }
  if process.nil?
    puts "iTunes is not running!"
  else
    left_sidebar = process.windows.first.splitter_groups.first
    library_panel = if (left_sidebar.splitter_groups.count == 0) 
      left_sidebar 
    else
      left_sidebar.splitter_groups.first
    end
    rows = library_panel.scroll_areas.first.outlines.first.rows.get

    # rows = process.windows[0].splitter_groups[0].scroll_areas[0].outlines[0].rows
    row_names = rows.map { |r| r.static_texts[0].name.get }
  
    shared_index = row_names.index("SHARED")
    next_index = (row_names.index("GENIUS") || row_names.index("PLAYLISTS"))
    lib_indices = ((shared_index + 1)..(next_index - 1)).to_a - [row_names.index("Home Sharing")].compact
    if lib_indices.empty?
      puts "No shared libraries available!"
    else
      lib_indices.each { |r_index|
        # itunes.activate
        puts "Adding library #{row_names[r_index]}"
        rows[r_index].actions["AXShowMenu"].perform
        sleep(0.1)
        sys.key_code 53 # escape the right-click menu
        puts "Done."
      }
    end
  
    # process.visible.set false
  end
end

namespace :dukejour do
  desc "make iTunes discover and connect to all shared libraries"
  task :discover do
    discover
  end
end
