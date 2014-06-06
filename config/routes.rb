require 'conduit/engine'

Conduit::Engine.routes.draw do
  resources :responses, only: [:create]
end
