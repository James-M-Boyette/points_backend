class Api::UserTransactionsController < ApplicationController
  def reconcile
    # @points_balance will track what happens to the initial user expenditure as it's reconciled with the transactions in our Transactions table
    @points_balance = params[:points].to_i

    # Trying to grab the timestamp and point amount associated
    # @test = Transaction.find_by(id: 1)

    # For all transactions, beginning with the first ENTERED in our table,
    Transaction.all.each do |transaction|
      # Store the current transaction (row)
      @current_transaction = transaction

      # Check, before we process the @current_transaction, whether our current @points_balance still has a remainder of points to be reconciled (a non-zero amount) ... if there are still points left, "subtract" the @current_transaction's point_amount from it
      if @points_balance > 0
        @points_balance += @current_transaction[:point_amount].to_i * -1
        # Store the sum of the current transaction's *payer* point_total and the current transaction's point_amount in an instanced variable
        @payer_balance = Payer.where(company_id: @current_transaction[:company_id]).pluck(:point_total).join().to_i + @current_transaction[:point_amount].to_i

        # Using the company_id of the current_transaction, find the Payer (in the "Payer" table) with the matching company_id; then update that payer's point_total with our @payer_balance
        Payer.where(company_id: @current_transaction[:company_id]).update(point_total: @payer_balance)
      else
        # If our @points_balance is =< 0, then we have apporitoned all user points and we can stop/ return data
        break
      end
    end

    # @test = Payer.find_by(company_id: 1)[:point_total]
    # Payer.find_by(company_id: 1)[:point_total] += Transaction.find_by(:id 4)[:point_amount]

    # @payer_total = Payer.find_by(id: 2)[:point_total].to_i

    # @payer_total += Transaction.find_by(id: 4)[:point_amount].to_i
    # Payer.find_by(company_id: 1).point_total = @payer_total
    # render json: @current_transaction

    # render json: @payer_total

    # render json: @points_balance
    # DELETE currently, we're getting -5,300 back. All this tells us is that we successfully exhausted @points_balance.

    # Payer.update(id: 1)[point_total: 654]
    # This updated all Payer totals to 654
    # Payer.update(point_total: 656)
    # This updated the first row entry's point total only
    # Payer.first.update(point_total: 666)
    # This updated the specified row, based on another variable
    # Payer.find(index).update(point_total: 666)

    # render json: Payer.find_by(id: 3)
    # render json: Payer.find_by(@current_transaction)
    # render json: Payer.find(@current_transaction[:company_id])
    # render json: Payer.find(:company_id)
    # render json: @current_transaction
    # render json: @current_transaction[:point_amount]
    # render json: @payer_balance

    # This grabs the payer via company ID
    # render json: Payer.where(company_id: 1)

    # This grabs a payer in the "payer table" using the company_id (instead of the table ID) of the current transaction ... it returns an array with a nested hash
    # render json: Payer.where(company_id: @current_transaction[:company_id])
    # render json: Payer.where(company_id: @current_transaction[:company_id])[:point_total]
    p @payer_balance.class
    # render json: @payer_balance
    render json: @points_balance
    # 2021-7-17T18:37 ... currently, we're storing a final, correct balance in points_balance of -5300

    # render json: Payer.where(company_id: 1).pluck(:point_total)
    # render json: Payer.find_by(@current_transaction[company_id:])

    # Render View page
    # render "index.json.jb"
  end
end

# Decomp:
# - I need to
#   > DONE run sequentially through the transactions table, starting with entry #1
#   > DONE add/subtract the associated value from the @points variable
#   > DONE WITH the caveat that the amount should be up-to whatever brings the overall balance of the Payer total to "0"
#   > Update the given payer's total after the @points_balance total is updated?
#   > AND a check: does the current transaction amount bring the @points_balance amount to "0" - if it does, complete the full transaction and set the payer's total to a negative number (could also only take what's needed from the transaction, but for this exercise, I believe it more important to maintain the integrity of the individual transactions)
# ... this begs the question: "What should happen if the remaining @points_balance amount is less than the amount of the current transaction?"
# Example: we started with a user expenditure of 5,000 ... after several transactions, the remaining @points_balance is now 100, but the transaction we're currently considering is for 200.
#... I assume this can never happen, based on the underlying implication that transactions are "known" to the devs/accounting, and that this scenario is impossible / already accounted for?

# - AFTER this is worked out,
#   > We need to figure out how to pre-sort the transactions based on timestamp
#   > Ensure that the "add transaction" route is a post route

# AND we need to sort out timestamp creation in the proper format
# NICE TO HAVE - a column in transactions that gets set to "cleared" once it's been reconciled
