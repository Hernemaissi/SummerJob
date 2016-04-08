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

class ContractProcessesController < ApplicationController
  before_filter :validate_claimer, only: [:update]
  before_filter :teacher_user, only: [:manage_users]

  def update
    process = ContractProcess.find(params[:id])
    update_receiver = params[:receiver] == "1"
    saved = (update_receiver) ? process.update_attributes(:receiver_id => current_user.id) : process.update_attributes(:initiator_id => current_user.id)
    if saved
      redirect_to company_mail_path(current_user.company, :anchor => "P")
    else
      flash[:error] = process.errors.full_messages.first
      redirect_to company_mail_path(current_user.company, :anchor => "P")
    end
    
  end
  
  def read_bids
    if current_user && current_user.company
      process = ContractProcess.find(params[:id])
      process.bids.each do |b|
        b.update_attribute(:read, true) if b.unread?(current_user.company)
      end
      process.rfps.each do |r|
        r.update_attribute(:read, true) if current_user.company == r.receiver
      end 
    end
    respond_to do |format|
        format.html {render nothing: true}
        format.js { render :json=>'{}', status: 200 }
      end
  end

  def manage_users
    company = Company.find(params[:company_id])
    process = ContractProcess.find(params[:id])
    if request.delete?
      user = process.resp_user(company)
      process.update_attribute(:initiator, nil) if user == process.initiator
      process.update_attribute(:receiver, nil) if user == process.receiver
      flash[:success] = "Removed #{user.name} from the contract process"
      redirect_to company_mail_path(company, :anchor => "P")
    else
      user = User.find(params[:user][:id])
      process.replace_user(user, company)
      flash[:success] = "#{user.name} is now the responsible user for this process"
      redirect_to company_mail_path(company, :anchor => "P")
    end
  end


  def validate_claimer
    process = ContractProcess.find(params[:id])
    update_receiver = params[:receiver] == "1"

    if update_receiver && !current_user.isOwner?(process.second_party)
      redirect_to company_mail_path(current_user.company, :anchor => "P"), :status => 403
    elsif !update_receiver && !current_user.isOwner?(process.first_party)
      render :nothing => true, :status => 403
      redirect_to company_mail_path(current_user.company, :anchor => "P"), :status => 403
    end

  end

end
