class Api::PayersController < ApplicationController
  def index
    @payers = Payer.all
    render "index.json.jb"
  end
end
