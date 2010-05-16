Dukejour::Application.routes.draw do |map|
  %w[songs].each do |name|
    match "#{name}/suggest/:fields", :to => 'name#suggest', :as => "suggest_#{name}".to_sym, :conditions => {:method => :get}
  end

  resources :entries, :member => {:vote => :post}
  resources :events, :collection => {:window => :get}
  resources :songs

  resources :libraries do
    resources :songs
  end

  root :to => 'entries#index'
end
