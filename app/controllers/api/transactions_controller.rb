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
      ## For any future transactions, update the given payer(s) point balances
      @payer_balance = Payer.where(company_id: @transaction[:company_id]).pluck(:point_total).join().to_i + @transaction[:point_amount].to_i

      ## Using the company_id of the current_transaction, find the Payer (in the "Payer" table) with the matching company_id; then update that payer's point_total with our @payer_balance
      Payer.where(company_id: @transaction[:company_id]).update(point_total: @payer_balance)
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
