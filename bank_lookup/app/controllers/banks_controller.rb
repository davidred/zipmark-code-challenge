class BanksController < ApplicationController

  def index

  end

  def show
    bank = Bank.find_by_routing_number(params[:id])
    render json: bank.output_json
  end

end
