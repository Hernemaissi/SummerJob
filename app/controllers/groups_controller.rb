class GroupsController < ApplicationController
  before_filter :teacher_user
  
  def index
    @groups = Group.all
    @group = Group.new
    @users = User.all
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
    @group = Group.find(params[:id])
    @group.update_attribute(:ready, true)
    @group.users.each do |u|
      u.send_group_confirm
    end
    flash["success"] = "Group marked as ready and mail sent to all group members"
    redirect_to @group
  end

  def search
    @group = Group.find(params[:id])
    @users = User.search(params[:field], params[:query])
    respond_to do |format|
      format.js
    end
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
    user.update_attribute(:position, nil)
    @group = Group.find(params[:id])
    redirect_to @group
  end

  def sort
    @qualities = Quality.all

    @free_users = User.where(:group_id => nil)
    @taken_users = User.where('group_id IS NOT NULL')
    puts @free_users
    puts @taken_users

    if (params[:quality_array])
      quality_array = params[:quality_array].split(",").delete_if(&:empty?)
      @free_users = User.get_with_qualities(quality_array, @free_users)
      @taken_users = User.get_with_qualities(quality_array, @taken_users)
    end

    respond_to do |format|

      format.html
      format.js

    end
  end

end
