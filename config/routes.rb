Jscov::Engine.routes.draw do
  resources :coverages, only: %i[create]
end
