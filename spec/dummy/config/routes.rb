Rails.application.routes.draw do
  mount Conduit::Engine => "/conduit"
end
