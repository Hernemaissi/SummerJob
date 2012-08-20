class BidsController < ApplicationController
  
  before_filter :is_allowed_to_see, only: [:show]
  before_filter :can_send, only: [:new, :create]
  before_filter :eligible_for_bid, only: [:new, :create]
  before_filter :bid_receiver, only: [:update]
  before_filter :only_if_bid_waiting, only: [:update]
  before_filter :in_round_two, only: [:new, :create, :update]
  
  def new
    @rfp = Rfp.find(params[:id])
    @bid = Bid.new
    @bid.rfp_id = @rfp.id
    unless @bid.can_bid?
      flash[:error] = "You cannot perform that action. Make sure you are of same type and the other company is still available"
      redirect_to @rfp
    else
      @bid.counter = (@rfp.sender.id == current_user.group.company.id)
      if @bid.counter
        @sender = @rfp.sender
        @receiver = @rfp.receiver
      else
        @sender = @rfp.receiver
        @receiver = @rfp.sender
      end
      @company = @sender
    end
  end

  def create
    @rfp = Rfp.find(params[:rfp_id])
    @bid = @rfp.bids.create(params[:bid])
    if @bid.can_bid?
      @bid.status = Bid.waiting
      @bid.counter = (@rfp.sender.id == current_user.group.company.id)
      @bid.create_offer
      if @bid.save
        flash[:success] = "Bid sent to recipient"
        redirect_to @bid
      else
        if @bid.counter
          @sender = @rfp.sender
          @receiver = @rfp.receiver
        else
          @sender = @rfp.receiver
          @receiver = @rfp.sender
        end
        @company = @sender
        render 'new'
      end
    else
      flash[:error] = "You cannot perform that action. Make sure you are of same type and the other company is still available"
      redirect_to @rfp
    end
  end

  def show
    @bid = Bid.find(params[:id])
    if @bid.unread?(current_user.company)
      @bid.read = true
      @bid.save(validate: false)
    end
  end 
  
  def update
    @bid = Bid.find(params[:id])
    @bid.status = params[:status]
    if params[:status] == Bid.accepted
      if @bid.can_bid?
        @contract = @bid.sign_contract!
        @bid.receiver.reject_all_standing_bids_with_type(@bid.sender.service_type)
        @bid.read = false
        @bid.save!
        redirect_to @contract
      else
        flash[:error] = "You cannot perform that action. The other company might have already made a contract with someone else"
        redirect_to @bid
      end
    else
      @bid.read = false
      @bid.save!
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
      flash[:error] = "There is no need to send a new bid. Either earlier bid was accepted or it is still under consideration"
      redirect_to @rfp.receiver
    end
  end
  
  def can_send
    if params[:id]
      @rfp = Rfp.find(params[:id])
    else
      @rfp = Rfp.find(params[:rfp_id])
    end
    unless signed_in? && (current_user.isOwner?(@rfp.receiver) || (current_user.isOwner?(@rfp.sender) && !@rfp.bids.empty?))
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
 

end
