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

class GroupsController < ApplicationController
  before_filter :teacher_user
  
  def index
    @groups = Group.all
    @group = Group.new
    @users = User.all
    @select = (params.has_key?("user_id")) ? true : false
    @selected_user = User.find(params["user_id"]) if params.has_key?("user_id")
    @qualities = Quality.order("order_number ASC").all
  end

  def show
    @group = Group.find(params[:id])
    @qualities = Quality.order("order_number ASC").all
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
    if params.has_key?(:version) && params[:version] == "old"
      redirect_to show_users_path(params[:id]) and return
    end
    redirect_to sort_users_path
  end
  
  def remove_member
    user = User.find(params[:user_id])
    user.update_attribute(:group_id, nil)
    user.update_attribute(:position, nil)
    user.remove_from_process
    @group = Group.find(params[:id])
    redirect_to @group
  end

  def sort
    @qualities = Quality.order("order_number ASC").all

    @free_users = User.where(:group_id => nil)
    @taken_users = User.where('group_id IS NOT NULL')

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

  def answers
    @group = Group.find(params[:id])
    @quality = Quality.find(params[:quality_id])
    @selected_user = User.find(params[:user_id])

    respond_to do |format|
      format.js

    end
  end

end
