Rails.application.routes.draw do
  post "/query", to: "query#execute"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
