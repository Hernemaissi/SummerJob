class EventsController < ApplicationController
  def read
    if current_user && current_user.company
      current_user.company.update_events
    end
  end
end
