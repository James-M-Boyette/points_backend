class Api::UserTransactionsController < ApplicationController
  def reconcile
    ## @points_balance will track what happens to the initial user expenditure as it's reconciled with the transactions in our Transactions table
    # @points_balance = params[:points].to_i

    # Demo version :
    @points_balance = 5000
    ## @expenditures will track what points are charged to each payer / company
    @expenditures = {}

    ## For all transactions, beginning with the earliest OCCURING (when the transaction originally occured / was timestamped rather than when it was entered into the Database)
    Transaction.order(:timestamp).each do |transaction|
      ## Store the current transaction (row)
      @current_transaction = transaction

      ## Check, before we process the @current_transaction, whether our current @points_balance still has a remainder of points to be reconciled (a non-zero amount) ... if there are still points left, "subtract" the @current_transaction's point_amount from it
      if @points_balance > 0
        @points_balance -= @current_transaction[:point_amount].to_i
        ## Store the sum of the current transaction's *payer* point_total and the current transaction's point_amount in an instanced variable
        @payer_balance = Payer.where(company_id: @current_transaction[:company_id]).pluck(:point_total).join().to_i - @current_transaction[:point_amount].to_i
        ## Using the company_id of the current_transaction, find the Payer (in the "Payer" table) with the matching company_id; then update that payer's point_total with our @payer_balance
        Payer.where(company_id: @current_transaction[:company_id]).update(point_total: @payer_balance)
        ## Log the company and transaction amount in an "@expenditures" hashmap, to be returned after:
        if @expenditures[Payer.where(company_id: transaction[:company_id]).pluck(:name).join()]
          @expenditures[Payer.where(company_id: transaction[:company_id]).pluck(:name).join()] += transaction[:point_amount] * -1
        else
          @expenditures[Payer.where(company_id: transaction[:company_id]).pluck(:name).join()] = transaction[:point_amount] * -1
        end
      else
        ## If our @points_balance is =< 0, then we have apporitoned all user points and we can stop
        ## But we need to refund any additional points expended to the last payer (because there are situations where the transaction is for more than the remaining user point_balance remaining), so ...
        break
      end
    end

    ## Get the last transaction's Payer ID
    @previous_transaction_payer_id = Transaction.where("timestamp < ?", @current_transaction[:timestamp]).order(:timestamp).last[:company_id]
    ## Store the remainder of points (whatever was in excess of the original, incoming user expenditure)
    @remainder_balance = Payer.where(company_id: @previous_transaction_payer_id).pluck(:point_total).join().to_i + @points_balance.to_i * -1
    ## Give back that remainder to the last payer
    Payer.where(company_id: @previous_transaction_payer_id).update(point_total: @remainder_balance)
    ## And adjust the final, logged expenditure of that payer in kind
    @expenditures[Payer.where(company_id: @previous_transaction_payer_id).pluck(:name).join()] += @remainder_balance

    ## Now, update the hashmap into the output format ...
    @send_back = []

    @expenditures.each do |k, v|
      @send_back << { payer: k, points: v }
    end

    render json: @send_back
  end
end
