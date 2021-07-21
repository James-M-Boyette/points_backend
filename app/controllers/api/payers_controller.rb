class Api::PayersController < ApplicationController
  def index
    ## Original index logic :

    # @payers = Payer.all
    # render "index.json.jb"

    ## To satisfy explicit output of exercise/request from Frontend designer, here is an alternative return :

    balances = {}
    Payer.all.each do |payer|
      balances[payer[:name]] = payer[:point_total]
    end

    render json: balances
  end

  def show
    @payer = Payer.find_by(id: params[:id])
    render "show.json.jb"
  end

  def reset
    Payer.where(company_id: 1).update(point_total: 1100)
    Payer.where(company_id: 2).update(point_total: 200)
    Payer.where(company_id: 3).update(point_total: 10000)
  end
end
