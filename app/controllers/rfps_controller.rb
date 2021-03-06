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

class RfpsController < ApplicationController
  before_filter :has_company
  before_filter :is_allowed_to_see, only: [:show]
  before_filter :not_in_round_one, only: [:new, :create]
  before_filter :can_send?, only: [:new, :create]
  before_filter :can_act?, only: [:new, :create]
  before_filter :read_only, only: [:new, :create]
  
  def new
    @rfp = Rfp.new
    @target_company = Company.find(params[:id])
    if !Rfp.valid_target?(current_user.company, @target_company)
      flash[:error] = "You do not need this company to operate so there is no need to send a RFP"
      redirect_to @target_company
    end
    @same_market = current_user.company.same_market?(@target_company)
    @rfp.receiver_id = @target_company.id
  end

  def create
    content = params[:rfp][:content]
    target_company = Company.find(params[:rfp][:receiver_id])
    process = ContractProcess.find_or_create_from_rfp(target_company, current_user)
    if !process.valid?
      flash.now[:error] = process.errors.full_messages.first
      @rfp = Rfp.new
      @target_company = target_company
      @rfp.receiver_id = @target_company.id
      render 'new'
    else
      rfp = current_user.group.company.send_rfp!(target_company, content)
      flash[:success] = "RFP sent to to #{target_company.name}"
      user = current_user
      current_user.update_attribute(:process_action_year, @game.sub_round)
      sign_in user
      Event.create_event("RFP sent", 1, Hash["company_name" => target_company.name], current_user.company.id)
      Event.create_event("RFP received", 2, Hash["company_name" => current_user.company.name], target_company.id)
      rfp.update_attribute(:contract_process_id, process.id)
      redirect_to current_user.group.company
    end

    
  end

  def show
    unless @rfp.read
      if @rfp.receiver == current_user.company
        @rfp.read = true
        @rfp.save(validate: false)
      end
    end
  end

  def update
    rfp = Rfp.find(params[:id])
    rfp.mark_all_bids
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
  
  private
  
  def is_allowed_to_see
    @rfp = Rfp.find(params[:id])
    unless signed_in? && (current_user.isOwner?(@rfp.sender) || current_user.isOwner?(@rfp.receiver))
      flash[:error] = "You are not allowed to view this item"
      redirect_to root_path
    end
  end

  def  can_send?
    if params[:id]
      @target_company = Company.find(params[:id])
    else
      @target_company = Company.find(params[:rfp][:receiver_id])
    end
    unless Rfp.can_send?(current_user, @target_company)
      flash[:error] = "You cannot send an RFP to this company"
      redirect_to @target_company
    end
  end
  
end
