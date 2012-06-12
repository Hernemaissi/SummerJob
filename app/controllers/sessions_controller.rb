class SessionsController < ApplicationController
  
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
