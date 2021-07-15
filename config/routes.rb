Rails.application.routes.draw do
  namespace :api do
    get "/transactions" => "transactions#index"
    post "/transactions/" => "transactions#create"
    get "/transactions/:id" => "transactions#show"

    get "/payers" => "payers#index"
    get "/payers/:id" => "payers#show"
  end
end
