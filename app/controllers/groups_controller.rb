class GroupsController < ApplicationController
  before_filter :teacher_user
  
  def index
    @groups = Group.all
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end
  
  def create
    @group = Group.create()
    if @group.save
      flash[:success] = "Succesfully created new group"
      redirect_to @group
    else
      flash.now[:error] = "Error creating a group, please contact admin"
      render 'new'
    end
  end

  def edit
  end

  def update
  end
  
  def show_users
    @group = Group.find(params[:id])
    @users = User.all
  end

  def add_member
    user = User.find(params[:user_id])
    user.update_attribute(:group_id, params[:id])
    redirect_to show_users_path(params[:id])
  end
  
  def remove_member
    user = User.find(params[:user_id])
    user.update_attribute(:group_id, nil)
    @group = Group.find(params[:id])
    redirect_to @group
  end
end
