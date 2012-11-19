CraftService::Application.routes.draw do
  root to: 'root#index'
  get 'root/initialize_listeners'
end
