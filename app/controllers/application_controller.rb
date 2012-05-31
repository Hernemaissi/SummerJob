class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  protected
    
    def teacher_user
      redirect_to(root_path) unless  signed_in? && current_user.isTeacher?
    end
    
    def signed_in_user
      store_location
      redirect_to signin_path, notice: "Please sign in." unless signed_in?
    end
    
end
