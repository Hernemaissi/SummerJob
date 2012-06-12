class BidsController < ApplicationController
  
  before_filter :is_allowed_to_see, only: [:show]
  before_filter :rfp_target, only: [:new, :create]
  before_filter :eligible_for_bid, only: [:new, :create]
  before_filter :bid_receiver, only: [:update]
  before_filter :only_if_bid_waiting, only: [:update]
  before_filter :enough_resources_for_contract, only: [:update]
  
  def new
    @rfp = Rfp.find(params[:id])
    @bid = Bid.new
    @bid.rfp_id = @rfp.id
  end

  def create
    @rfp = Rfp.find(params[:rfp_id])
    @bid = @rfp.bids.create(params[:bid])
    @bid.status = Bid.waiting
    if @bid.save
      flash[:success] = "Bid sent to recipient"
      redirect_to @bid
    else
      render 'new'
    end
  end

  def show
    @bid = Bid.find(params[:id])
  end
  
  def update
    @bid = Bid.find(params[:id])
    @bid.status = params[:status]
    if params[:status] == Bid.accepted
      @contract = @bid.sign_contract!(params[:provider_id], params[:buyer_id])
      @contract.update_values
      @bid.save
      redirect_to @contract
    else
      @bid.save
      redirect_to @bid
    end
  end
  
  private
  
  def eligible_for_bid
    if params[:id]
      @rfp = Rfp.find(params[:id])
    else
      @rfp = Rfp.find(params[:rfp_id])
    end
    unless @rfp.bids.empty? || (!@rfp.bids.empty? && @rfp.bids.last.rejected?)
      flash[:error] = "There is no need to send a new bid. Either earlier bid was accepted or they are still considering it"
      redirect_to @rfp.receiver
    end
  end
  
  def rfp_target
    if params[:id]
      @rfp = Rfp.find(params[:id])
    else
      @rfp = Rfp.find(params[:rfp_id])
    end
    unless signed_in? && current_user.isOwner?(@rfp.receiver)
      redirect_to root_path
    end
  end
  
  def is_allowed_to_see
    @bid = Bid.find(params[:id])
    unless signed_in? && (current_user.isOwner?(@bid.rfp.sender) || current_user.isOwner?(@bid.rfp.receiver))
      flash[:error] = "You are not allowed to view this item"
      redirect_to root_path
    end
  end
  
  def bid_receiver
    @bid = Bid.find(params[:id])
    unless signed_in? && current_user.isOwner?(@bid.receiver)
      redirect_to root_path
    end
  end
  
  def only_if_bid_waiting
    @bid = Bid.find(params[:id])
    unless @bid.waiting?
      flash[:error] = "Your company has already made a decision regarding this bid"
      redirect_to @bid
    end
  end
  
  def enough_resources_for_contract
    if params[:status] == Bid.accepted
      @bid = Bid.find(params[:id])
      buyer = Company.find(params[:buyer_id])
      seller = Company.find(params[:provider_id])
      if @bid.amount > buyer.assets || @bid.service_provided > buyer.get_max(seller.service_type)
        flash[:error] = "You cannot accept this contract. Either you don't have enough assets or your max #{seller.type_to_s} is too low"
        redirect_to @bid
      end
    end
  end
end
