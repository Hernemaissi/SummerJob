class BidsController < ApplicationController
  
  def new
    @rfp = Rfp.find(params[:id])
    @bid = Bid.new
    @bid.rfp_id = @rfp.id
  end

  def create
  end

  def show
  end
end
