=begin
This file is part of Network Service Business Game.

    Network Service Business Game is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Network Service Business Game is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Network Service Business Game.  If not, see <http://www.gnu.org/licenses/>
=end

class BidsController < ApplicationController
  
  before_filter :is_allowed_to_see, only: [:show]
  before_filter :can_send, only: [:new, :create]
  before_filter :eligible_for_bid, only: [:new, :create]
  before_filter :can_act?, only: [:new, :create]
  before_filter :bid_receiver, only: [:update]
  before_filter :only_if_bid_waiting, only: [:update]
  before_filter :not_in_round_one, only: [:new, :create, :update]
  before_filter :can_answer?, only: [:update]
  before_filter :read_only, only: [:new, :create, :update]
  
  def new
    if request.xhr?
      @receiver = Company.find(params[:company_id])
      @bid = Bid.new(params[:bid])
      

      #@bid.counter = (rfp.sender.id == current_user.group.company.id)
    else
      @receiver = Company.find(params[:id])
      @bid = Bid.new 
       #@bid.counter = (@rfp.sender.id == current_user.group.company.id)
    end
=begin
    if @bid.counter
      @sender = @rfp.sender
      @receiver = @rfp.receiver
    else
      @sender = @rfp.receiver
      @receiver = @rfp.sender
    end
=end
    @sender = current_user.company
    @company = @sender

    @bid.sender = current_user.company
    @bid.receiver = @receiver
    @bid.create_offer if request.xhr?
    respond_to do |format|

      format.html
      format.js

    end

  end

  def create
    @company = Company.find(params[:company_id])

    process = ContractProcess.find_or_create_from_offer(@company, current_user)
    flash.now[:error] = process.errors.full_messages.first if !process.valid?

    @bid = Bid.new(params[:bid])
    if Bid.can_offer?(current_user, @company)
      @bid.status = Bid.waiting
      @bid.sender = current_user.company
      @bid.receiver = @company
      @bid.create_offer
      #@bid.counter = (@rfp.sender.id == current_user.group.company.id)
      @bid.remaining_duration = @bid.agreed_duration
      if @bid.save && process.valid?
        flash[:success] = "Bid sent to recipient"
        @bid.update_attribute(:contract_process_id, process.id)
        user = current_user
        current_user.update_attribute(:process_action_year, @game.sub_round)
        sign_in user
        Event.create_event("Bid received", 3, Hash["company_name" => @bid.sender.name], @bid.receiver.id)
        Event.create_event("Bid sent",12, Hash["company_name" => @bid.receiver.name], @bid.sender.id)
        redirect_to @bid
      else
=begin
        if @bid.counter
          @sender = @rfp.sender
          @receiver = @rfp.receiver
        else
          @sender = @rfp.receiver
          @receiver = @rfp.sender
        end
=end
        @receiver = @company
        @sender = current_user.company
        process.destroy
        render 'new'
      end
    else
      flash[:error] = "You cannot perform that action. Make sure you are of same type and the other company is still available"
      redirect_to current_user.company
    end
  end

  def show
    @bid = Bid.find(params[:id])
    @company = current_user.company
    if @bid.unread?(current_user.company)
      @bid.read = true
      @bid.save(validate: false)
    end
  end 
  
  def update
    @bid = Bid.find(params[:id])
    @bid.status = params[:status]
    if params[:status] == Bid.accepted
      if @bid.can_accept?
        @contract = @bid.sign_contract!
        @bid.read = true
        @bid.save!
        Event.create_event("Contract formed", 0, Hash["company_name" => @bid.sender.name], @bid.receiver.id)
        Event.create_event("Contract formed", 0, Hash["company_name" => @bid.receiver.name], @bid.sender.id)
        redirect_to @contract
      else
        flash[:error] = "You cannot perform that action. The other company might have already made a contract with someone else"
        redirect_to @bid
      end
    else
      @bid.update_attribute(:read, false)
      @bid.update_attribute(:expired, true) if params[:expired] == "1"
      @bid.update_attribute(:reject_message, params[:bid][:reject_message]) unless @bid.expired
      Event.create_event("Bid rejected", 13, Hash["company_name" => @bid.receiver.name], @bid.sender.id) unless @bid.expired
      Event.create_event("Bid canceled", 15, Hash["company_name" => @bid.sender.name], @bid.receiver.id) if @bid.expired
      redirect_to @bid
    end
  end
  
  private
  
  def eligible_for_bid
    if params[:id]
      @company = Company.find(params[:id])
    else
      @company = Company.find(params[:company_id])
    end
    unless Bid.need_offer?(current_user.company, @company)
      flash[:error] = "There is no need to send a new bid. Either earlier bid was accepted or it is still under consideration"
      redirect_to @rfp.receiver
    end
  end
  
  def can_send
    if params[:id]
      @company = Company.find(params[:id])
    else
      @company = Company.find(params[:company_id])
    end
    unless Bid.can_offer?(current_user, @company)
      redirect_to root_path
    end
  end
  
  def is_allowed_to_see
    @bid = Bid.find(params[:id])
    unless signed_in? && (current_user.isOwner?(@bid.sender) || current_user.isOwner?(@bid.receiver))
      flash[:error] = "You are not allowed to view this item"
      redirect_to root_path
    end
  end
  
  def bid_receiver
    @bid = Bid.find(params[:id])
    unless signed_in? && current_user.isOwner?(@bid.receiver) || (signed_in? && current_user.isOwner?(@bid.sender) && params[:expired] == "1")
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

  def can_answer?
    bid = Bid.find(params[:id])
    target_company = bid.sender
    unless ContractProcess.can_act?(current_user, target_company)
      flash[:error] = "Only the resp user can perform that action"
      redirect_to current_user.company
    end
  end
 

end
