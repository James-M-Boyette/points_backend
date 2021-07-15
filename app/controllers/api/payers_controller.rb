class Api::PayersController < ApplicationController
  def index
    @payers = Payer.all
    render "index.json.jb"
  end

  def show
    @payer = Payer.find_by(id: params[:id])
    render "show.json.jb"
  end
end
