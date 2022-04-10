class StaffController < ApplicationController

  #TODO: actual search
  #(currently just filling with something to test partials)
  def search
    if params[:search]
      @results = current_user.staff_favourites_objects
    else
      @results = current_user.staff_favourites_objects
    end
  end
end
