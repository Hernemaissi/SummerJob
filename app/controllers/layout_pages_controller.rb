class LayoutPagesController < ApplicationController
  def index
    if request.post?
    if params[:query]
      @companies = Company.where('name LIKE ?', "%#{params[:query]}%")
      @usersbyname = User.where('name LIKE ?', "%#{params[:query]}%")
      @usersbystudentnumber = User.where('student_number LIKE ?', "%#{params[:query]}%")
    else
      @companies = Company.where('name LIKE ?', "%#{params[:queryofstudent]}%")
      @usersbyname = []
      @usersbystudentnumber = []
    end
    respond_to do |format|
      format.html
    end
  else
    redirect_to root_path
  end
  end

  
end
