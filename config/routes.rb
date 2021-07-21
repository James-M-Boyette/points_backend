Rails.application.routes.draw do
  namespace :api do
    get "/transactions" => "transactions#index"
    ## https://points-payer-backend.herokuapp.com/api/transactions
    post "/transactions/" => "transactions#create"
    get "/transactions/:id" => "transactions#show"
    ## For seeding the Database externally - unnecessary w/ Heroku
    # get "/transaction/seed" => "transactions#seed"

    get "/points_balance" => "payers#index"
    get "/payers/reset" => "payers#reset"
    ## https://points-payer-backend.herokuapp.com/api/points_balance
    # get "/payers" => "payers#index"
    get "/payers/:id" => "payers#show"

    # post "/spend_points" => "user_transactions#reconcile"
    ## For Demo purposes
    get "/spend_points" => "user_transactions#reconcile"
    ## https://points-payer-backend.herokuapp.com/api/spend_points
  end
end

# heroku pg:reset --confirm points-payer-backend
# heroku run rails db:setup
