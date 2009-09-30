ActionController::Routing::Routes.draw do |map|

  map.resources :votes

  %w[tracks].each do |name|
    map.send "suggest_#{name}".to_sym, "#{name}/suggest/:fields", :controller => name, :action => 'suggest', :conditions => {:method => :get}
  end

  map.resources :entries, :member => {:play => :post} do |entry|
    entry.resources :votes
  end

  map.resources :events, :collection => {:window => :get} do |event|
    event.resources :entries
  end

  map.resources :tracks

  map.resources :libraries do |library|
    library.resources :tracks
  end

  map.root :controller => 'entries', :action => 'index'
end
