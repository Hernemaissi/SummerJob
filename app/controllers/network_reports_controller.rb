class NetworkReportsController < ApplicationController

  def show
    @report = NetworkReport.find(params[:id])
  end
end
