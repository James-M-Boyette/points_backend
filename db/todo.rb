# This is my To-Do list / decomp file (moved from user_transactions controller for cleanliness-sake)

# Decomp:
# - I need to
#   > DONE create basic routes
#   > DONE make sure the post logic for TRANSACTIONS adds the point amount to the PAYER point balance
#   > DONE Ensure that the "add transaction" route is a post route
#   > DONE run through the transactions table - now based on order of timestamps
#   > DONE add/subtract the associated value from the @points variable
#   > DONE WITH the caveat that the amount should be up-to whatever brings the overall balance of the Payer total to "0"
#   > DONE Update the given payer's total after the @points_balance total is updated
#   > DONE Re-allocate excess points - those not needed to resolve a user expenditure - back to the payer
#   > DONE AFTER payer balance updates, Store each transaction's company & point value (?positive or negative?) in an hash map
#   > DONE We need to figure out how to pre-sort the transactions based on timestamp

#   > DONE We need to return an hashmap of payer names and point totals only (string:integer) for payer index route

#   > Remove print statements & extraneous comments
#   > Upload to Git & Heroku
#   > Confirm routes work as-is w/o creation of Frontend
#   > Create Readme w/ 1) How to use all routes & what those routes are + notice about seeds file, and 2) Note the things I learned on this project

# DEPRECIATE - - -
#   > AND a check: does the current transaction amount bring the @points_balance amount to "0" - if it does, complete the full transaction and set the payer's total to a negative number (could also only take what's needed from the transaction, but for this exercise, I believe it more important to maintain the integrity of the individual transactions)
# ... this begs the question: "What should happen if the remaining @points_balance amount is less than the amount of the current transaction?"
# Example: we started with a user expenditure of 5,000 ... after several transactions, the remaining @points_balance is now 100, but the transaction we're currently considering is for 200.
#... I assume this can never happen, based on the underlying implication that transactions are "known" to the devs/accounting, and that this scenario is impossible / already accounted for?
# NICE TO HAVE - a column in transactions that gets set to "cleared" once it's been reconciled ?
# NICE TO HAVE - figure out how records would be created with the timestamp specified
