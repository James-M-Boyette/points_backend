class Api::TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
    render "index.json.jb"
  end

  def create
    @transaction = Transaction.new(
      company_id: params[:company_id],
      point_amount: params[:point_amount],
      timestamp: params[:timestamp],
    )

    if @transaction.save
      render "show.json.jb"
    else
      render json: { errors: @transaction.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @transaction = Transaction.find_by(id: params[:id])
    render "show.json.jb"
  end
end
