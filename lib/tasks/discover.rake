def find_rows_containing elem, str
  if elem.respond_to?(:rows) && elem.rows.detect { |r| r.static_texts.detect { |t| t.name == str } }
    elem.rows 
  else
    [:outlines, :scroll_areas, :splitter_groups, :windows].each { |method|
      elem.send(method).each { |o| found = find_rows_containing(o, str); return found if found }
    }
    nil
  end
end

def discover
  require 'rbosa'
  itunes = OSA.app('iTunes')

  sys = OSA.app("System Events")
  process = sys.processes.find { |p| p.name == "iTunes" }
  if process.nil?
    puts "iTunes is not running!"
  else
    # currently_visible = process.visible?
  
    rows = (find_rows_containing(process, "LIBRARY") or (puts "Could not find LIBRARY"; []))

    # rows = process.windows[0].splitter_groups[0].scroll_areas[0].outlines[0].rows
    row_names = rows.map { |r| r.static_texts[0].name }
  
    shared_index = row_names.index("SHARED")
    if shared_index.nil?
      puts "No shared libraries available!"
    else
      ((shared_index + 1)..((row_names.index("GENIUS") || row_names.index("PLAYLISTS")) - 1)).each { |r_index|
        itunes.activate
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
  
    process.visible = false
  end
end

namespace :dukejour do
  desc "make iTunes discover and connect to all shared libraries"
  task :discover do
    discover
  end
end
