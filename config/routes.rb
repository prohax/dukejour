ActionController::Routing::Routes.draw do |map|

  %w[tracks].each do |name|
    map.send "suggest_#{name}".to_sym, "#{name}/suggest/:fields", :controller => name, :action => 'suggest', :conditions => {:method => :get}
  end

  map.resources :entries

  map.resources :tracks, :member => {:get => :post, :stop => :post}

  map.resources :libraries do |library|
    library.resources :tracks, :member => {:get => :post, :stop => :post}
  end
end
