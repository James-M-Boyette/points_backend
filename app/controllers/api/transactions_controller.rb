class Api::TransactionsController < ApplicationController
  def index
    @transactions = Transaction.all
    render "index.json.jb"
  end
end
