ActionController::Routing::Routes.draw do |map|
  map.resources :tracks, :member => {:get => :post, :stop => :post}

  map.resources :libraries do |library|
    library.resources :tracks, :member => {:get => :post, :stop => :post}
  end
end
