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
    outline = library_panel.scroll_areas.first.outlines
    outline_y_min = outline.position.get.flatten.last
    outline_y_bounds = outline_y_min..(outline_y_min + outline.size.get.flatten.last)
    rows = outline.first.rows.get
    row_names = rows.map { |r| r.static_texts[0].name.get }
  
    shared_index = row_names.index("SHARED")
    next_index = (row_names.index("GENIUS") || row_names.index("PLAYLISTS"))
    lib_indices = ((shared_index + 1)..(next_index - 1)).to_a - [row_names.index("Home Sharing")].compact
    if lib_indices.empty?
      puts "No shared libraries available!"
    else
      lib_indices.each { |r_index|
        y_pos = rows[r_index].position.get.last
        if (outline_y_bounds.include? y_pos)
          puts "Adding library #{row_names[r_index]}"
          rows[r_index].actions["AXShowMenu"].perform
          sleep(0.1)
          sys.key_code 53 # escape the right-click menu
          puts "Done."
        else
          puts "Sorry, you need to have the shared library visible in the iTunes window. Sucky, I know."
          puts "TODO - HIT SCROLLBARS TO MAKE VISIBLE"
        end
      }
    end
  end
end

namespace :dukejour do
  desc "make iTunes discover and connect to all shared libraries"
  task :discover do
    discover
  end
end
