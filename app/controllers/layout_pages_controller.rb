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
