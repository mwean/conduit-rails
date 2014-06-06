ConduitRails::Engine.routes.draw do
  resources :responses, only: [:create]
end
