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
      else
        # If our @points_balance is =< 0, then we have apporitoned all user points and we can stop/ return data
        break
      end
    end

    # render json: @current_transaction
    render json: @points_balance
    # DELETE currently, we're getting -5,300 back. All this tells us is that we successfully exhausted @points_balance.

    # Render View page
    # render "index.json.jb"
  end
end

# Decomp:
# - I need to
#   > DONE run sequentially through the transactions table, starting with entry #1
#   > DONE add/subtract the associated value from the @points variable
#   > DONE WITH the caveat that the amount should be up-to whatever brings the overall balance of the Payer total to "0"
#   > AND the caveat / check that the current transaction amount DOESN'T bring the @points amount to "0" - if it does, only ?take what's needed from the transaction? ... or maybe complete the full transaction and set the payer's total to a negative number
# ... this begs the question: "What should happen if the remaining @points_balance amount is less than the amount of the current transaction?"
# Example: we started with a user expenditure of 5,000 ... after several transactions, the remaining @points_balance is now 100, but the transaction we're currently considering is for 200.
#... I assume this can never happen, based on the underlying implication that transactions are "known" to the devs/accounting, and that this scenario is impossible / already accounted for?
#   > anyway ...
#   > ? Update the given payer's total after the @points total is updated?
#   > ?and then perform a check to see whether

# - AFTER this is worked out,
#   > We need to figure out how to pre-sort the transactions based on timestamp

# AND we need to sort out timestamp creation in the proper format
# NICE TO HAVE - a column in transactions that gets set to "cleared" once it's been reconciled
