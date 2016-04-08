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

class SessionsController < ApplicationController
  skip_filter :finished
  skip_before_filter :still_calculating
  skip_before_filter :registered
  
  def new
  end
  
  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      if request.env['HTTP_USER_AGENT'] =~ /[^\(]*[^\)]Chrome\//
        if user.has_company?
          redirect_to user.company
        else
          redirect_to user
        end
      else
        if user.has_company?
          redirect_back_or user.company
        else
          redirect_back_or user
        end
      end
    else
      flash.now[:error] = "Invalid email/password combination"
      render 'new'
    end
  end
  
  def destroy
    sign_out
    flash[:notice] = "Logged out succesfully"
    redirect_to root_path
  end
  
end
