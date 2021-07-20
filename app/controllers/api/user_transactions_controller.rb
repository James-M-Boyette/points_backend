class Api::UserTransactionsController < ApplicationController
  def reconcile
    # @points_balance will track what happens to the initial user expenditure as it's reconciled with the transactions in our Transactions table
    @points_balance = params[:points].to_i
    @expenditures = {}
    # @expenditures = []

    # For all transactions, beginning with the first ENTERED in our table,
    Transaction.all.each do |transaction|
      # Store the current transaction (row)
      @current_transaction = transaction

      # Check, before we process the @current_transaction, whether our current @points_balance still has a remainder of points to be reconciled (a non-zero amount) ... if there are still points left, "subtract" the @current_transaction's point_amount from it
      if @points_balance > 0
        @points_balance -= @current_transaction[:point_amount].to_i
        # Store the sum of the current transaction's *payer* point_total and the current transaction's point_amount in an instanced variable
        @payer_balance = Payer.where(company_id: @current_transaction[:company_id]).pluck(:point_total).join().to_i - @current_transaction[:point_amount].to_i
        # Using the company_id of the current_transaction, find the Payer (in the "Payer" table) with the matching company_id; then update that payer's point_total with our @payer_balance
        Payer.where(company_id: @current_transaction[:company_id]).update(point_total: @payer_balance)

        # Ver 1: Log the company and transaction amount in an "@expenditures" hashmap, to be returned after:
        # if @expenditures[Payer.where(company_id: transaction[:company_id]).pluck(:name).join()]
        #   @expenditures[Payer.where(company_id: transaction[:company_id]).pluck(:name).join()] += transaction[:point_amount] * -1
        #   p "The payer already existed, so we added to their total"
        # else
        #   @expenditures[Payer.where(company_id: transaction[:company_id]).pluck(:name).join()] = transaction[:point_amount] * -1
        #   p "The payer didn't exist, so we created them"
        # end
        # Ver 2: Store each company and its transaction amount as individual hashes in an array:
        if @expenditures[Payer.where(company_id: transaction[:company_id]).pluck(:name).join()]
          @expenditures[Payer.where(company_id: transaction[:company_id]).pluck(:name).join()] += transaction[:point_amount] * -1
          p "The payer already existed, so we added to their total"
        else
          @expenditures[Payer.where(company_id: transaction[:company_id]).pluck(:name).join()] = transaction[:point_amount] * -1
          p "The payer didn't exist, so we created them"
        end

        # They want individual hashes, with "payer" and "points" keys
      else
        # If our @points_balance is =< 0, then we have apporitoned all user points and we can stop
        # But we need to refund any additional points expended to the last payer (because there are situations where the transaction is for more than the remaining user point_balance remaining), so ...
        break
      end
    end

    # Get the last transaction's ID
    @previous_transaction_id = Transaction.where(id: (@current_transaction[:id] - 1)).pluck(:company_id).join().to_i
    # Store the remainder of points (whatever was in excess of the original, incoming user expenditure)
    @remainder_balance = Payer.where(company_id: @previous_transaction_id).pluck(:point_total).join().to_i + @points_balance.to_i * -1
    # Give back that remainder to the last payer
    Payer.where(company_id: @previous_transaction_id).update(point_total: @remainder_balance)
    # And adjust the final, logged expenditure of that payer in kind
    ## Version 1: Hashmap
    @expenditures[Payer.where(company_id: @previous_transaction_id).pluck(:name).join()] += @remainder_balance

    ## Version 2: update the hashmap into the output format ...
    @send_back = []

    @expenditures.each do |k, v|
      @send_back << { payer: k, points: v }
    end

    render json: @send_back
    # render json: @payer_balance

    # render "index.json.jb"
  end
end

# Decomp:
# - I need to
#   > DONE run sequentially through the transactions table, starting with entry #1
#   > DONE add/subtract the associated value from the @points variable
#   > DONE WITH the caveat that the amount should be up-to whatever brings the overall balance of the Payer total to "0"
#   > DONE Update the given payer's total after the @points_balance total is updated
#   > DONE Ensure that the "add transaction" route is a post route
#   > DONE Re-allocate excess points - those not needed to resolve a user expenditure - back to the payer
#   > AFTER payer balance updates, Store each transaction's company & point value (?positive or negative?) in an hash map
#   > We need to figure out how to pre-sort the transactions based on timestamp
#   > We need to sort out timestamp creation in the proper format
#   > We need to return an hashmap of payer names and point totals only (string:integer) for payer index route
# NICE TO HAVE - a column in transactions that gets set to "cleared" once it's been reconciled ?
#   > Remove print statements & extraneous comments
#   > Upload to Git & Heroku
#   > Confirm routes work as-is w/o creation of Frontend
#   > Create Readme w/ 1) How to use all routes & what those routes are + notice about seeds file, and 2) Note the things I learned on this project

# DEPRECIATE - - -
#   > AND a check: does the current transaction amount bring the @points_balance amount to "0" - if it does, complete the full transaction and set the payer's total to a negative number (could also only take what's needed from the transaction, but for this exercise, I believe it more important to maintain the integrity of the individual transactions)
# ... this begs the question: "What should happen if the remaining @points_balance amount is less than the amount of the current transaction?"
# Example: we started with a user expenditure of 5,000 ... after several transactions, the remaining @points_balance is now 100, but the transaction we're currently considering is for 200.
#... I assume this can never happen, based on the underlying implication that transactions are "known" to the devs/accounting, and that this scenario is impossible / already accounted for?
