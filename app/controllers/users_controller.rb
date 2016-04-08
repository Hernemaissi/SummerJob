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

class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :show]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :teacher_user,     only: [:destroy, :index, :set_as_admin, :resend_registration_mail, :text_data]
  before_filter :sign_up_open?, only: [:new, :create]
  before_filter :needs_student_mode, only: [:set_student_mode]
  skip_before_filter :registered
  
  def new
    if signed_in? 
      redirect_to root_path
    end
    @user = User.new
    @qualities = Quality.order("order_number ASC")
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      @user.send_mail
      sign_in @user
      flash[:success] = "Welcome to the Network Service Business Game!"
      redirect_to @user
    else
       @qualities = Quality.order("order_number ASC")
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if params[:user][:position] && current_user.teacher?
      if User.validate_proper_position(params[:user][:position])
        @user.update_attribute(:position, params[:user][:position])
        redirect_to users_path
      else
        flash.now[:error] = "Invalid position"
        render 'edit'
      end
    else
      if @user.update_attributes(params[:user])
        flash[:success] = "Profile updated"
        sign_in @user
        redirect_to @user
      else
        render 'edit'
      end
    end
  end

  def update_position
    @user = User.find(params[:id])
     if User.validate_proper_position(params[:position]) && !@user.group.position(params[:position])
       @user.update_attribute(:position, params[:position])
       sign_in @user
       flash[:success] = "Succesfully assigned yourself as #{params[:position]}"
       redirect_to @user.company
     else
       flash[:error] = "Invalid position"
       redirect_to @user.company
     end
  end
  
  def index
    @users = User.all
    @qualities = Quality.all

    respond_to do |format|

      format.html
      format.js

    end

  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

  def search
    @users = User.search(params[:field], params[:query])
    respond_to do |format|
      format.js
    end
  end

  def autocomplete
     users = User.search(params[:field], params[:term])
     if params[:field] == User.search_fields[0]
       users = users.select(:name).uniq
       render json: users.map{ |user| {:label => user.name, :value => user.name} }
     elsif params[:field] == User.search_fields[1]
       users = users.select(:student_number).uniq
        render json: users.map{ |user| {:label => user.student_number, :value => user.student_number} }
     elsif params[:field] == User.search_fields[2]
       users = users.select(:department).uniq
       render json: users.map{ |user| {:label => user.department, :value => user.department} }
      elsif params[:field] == User.search_fields[3]
       company_names = []
       users.each do |u|
         company_names << u.company.name unless company_names.include?(u.company.name)
       end
       render json: company_names.map{ |name| {:label => name, :value => name} }
     end
  end

  def set_as_admin
    @user = User.find(params[:id])
    @user.teacher = true
    @user.save(validate: false)
    redirect_to @user
  end

  def set_student_mode
    if current_user.teacher
      company = Company.find(params[:company_id])
      user = current_user
      user.update_attribute(:student_mode, true)
      user.update_attribute(:teacher, false)
      user.update_attribute(:group_id, company.group_id)
      sign_in user
      flash[:success] = "Set yourself as user of company #{company.name}. Set yourself back to admin view from the account tab in the header."
      redirect_to company
    else
      user = current_user
      user.update_attribute(:student_mode, false)
      user.update_attribute(:teacher, true)
      user.update_attribute(:group_id, nil)
      sign_in user
      flash[:success] = "Returned to admin view"
      redirect_to root_path
    end
  end

  def complete_registration
    @user = User.find_by_registration_token(params[:token])
    if @user
      @user.update_attribute(:registered, true)
      #sign_in @user
      flash[:success] = "Registration succesful. Sign-in to complete registration"
      redirect_to root_path
    else
      redirect_to root_path
    end
  end

  def complete_group_registration
    @user = User.find_by_group_token(params[:token])
    if @user
      @user.update_attribute(:group_registered, true)
      sign_in @user
      flash[:success] = "Registered to group"
      redirect_to @user
    else
      redirect_to root_path
    end
  end

  def resend_registration_mail
    @user = User.find(params[:id])
    @user.send_mail
    flash[:success] = "Succesfully resent registration mail"
    redirect_to @user
  end

  def text_data
    data = User.user_data_txt
    render text: data
  end

  
  private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || current_user.teacher?
    end

    def sign_up_open?
      unless @game.sign_up_open
        flash[:error] = "Registration has been closed"
        redirect_to root_path
      end
    end

    def needs_student_mode
      unless current_user.teacher || current_user.student_mode
        redirect_to root_path
      end
    end
  
end
