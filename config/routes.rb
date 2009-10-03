ActionController::Routing::Routes.draw do |map|

  %w[tracks].each do |name|
    map.send "suggest_#{name}".to_sym, "#{name}/suggest/:fields", :controller => name, :action => 'suggest', :conditions => {:method => :get}
  end

  map.resources :entries, :member => {:play => :post, :vote => :post}
  map.resources :events, :collection => {:window => :get}
  map.resources :tracks

  map.resources :libraries do |library|
    library.resources :tracks
  end

  map.root :controller => 'entries', :action => 'index'
end
