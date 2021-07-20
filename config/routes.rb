Rails.application.routes.draw do
  namespace :api do
    get "/transactions" => "transactions#index"
    post "/transactions/" => "transactions#create"
    get "/transactions/:id" => "transactions#show"

    get "/points_balance" => "payers#index"
    ## http://localhost:3000/api/points_balance
    # get "/payers" => "payers#index"
    get "/payers/:id" => "payers#show"

    post "/spend_points" => "user_transactions#reconcile"
    ## http://localhost:3000/api/spend_points
  end
end
