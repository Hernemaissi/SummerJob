class EventsController < ApplicationController
  def read
    if current_user && current_user.company
      event = Event.find(params[:event_id].to_i)
      event.update_attribute(:read, true) if current_user.company.events.all.include?(event)
    end
  end

  def settings
    @company = nil
    if current_user && current_user.company
      puts params[:show]
      current_user.company.update_attribute(:show_read_events, params[:show])
      @company = current_user.company
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

end
