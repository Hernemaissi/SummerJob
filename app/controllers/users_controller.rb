class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :show]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :teacher_user,     only: [:destroy, :index]
  
  def new
    if signed_in? 
      redirect_to root_path
    end
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Network Business Game!"
      redirect_to @user
    else
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
  
  def index
    @users = User.all
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

  
  private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || current_user.teacher?
    end
  
end
