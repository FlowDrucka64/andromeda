# Controller used for all staff functionalities (Search/Detail View/ Favourite Management)
# "extending" from the BaseController
class StaffController < BaseController

  # Showing the current user's favourites
  def favourites
    @favourites = load_favourite_bundle(current_user.staff_favourites)
    # "calculation" of the results to display on the current page of the results
    @favourites["slice"] = @favourites["objects"].slice(PAGE_ENTRY_COUNT * (params[:p].to_i - 1), PAGE_ENTRY_COUNT)
  end

  # Creating new favourite (persisting to db)
  def create
    if params[:id]
      unless is_favourite(params[:id])
        current_user.staff_favourites.create(staff_id: params[:id], notes: "", keywords: "")
        flash[:notice] = "User " + params["name"].to_s + " added to favourites"
        redirect_back(fallback_location: staff_search_url)
      end
    end
  end

  # Displays an edit form for a favourite given by the id in params
  def edit
    @favourites = load_favourite_bundle(current_user.staff_favourites)
    @favourite = current_user.staff_favourites.where(:id => params["id"].to_i)[0]
    @fav_name = get_fav_name(params["id"].to_i)
  end

  # Update fields of a staff-favourite given by id in params
  # This is where the data from the edit form is posted to and processed
  def update
    @favourite = current_user.staff_favourites.where(:id => params["id"].to_i)[0]
    if @favourite.update(favourite_params)
      flash[:notice] = "Updated"
    else
      flash[:notice] = "Error updating"
    end
    redirect_to staff_favourites_path(p: 1)
  end

  # delete staff favourite entry
  def destroy
    if params[:id]
      @favourite = current_user.staff_favourites.where(:id => params["id"].to_i)[0]
      @favourite.destroy
      flash[:notice] = "Deleted"
      redirect_to staff_favourites_path(p: 1)
    end
  end

  def print
    @favourites = load_favourite_bundle(current_user.staff_favourites)['objects']
  end

  helper_method :is_favourite # used for case distinction when rendering detail information
  helper_method :get_favourite_data # used for rendering detail information
  helper_method :get_fav_url

  private

  # override of base_controller
  def fetch_url
    return BASE_API_URL + STAFF_FETCH_URI
  end

  # override of base_controller
  def search_url
    return BASE_API_URL + STAFF_SEARCH_URI
  end

  def search_params
    "&max_treffer=" + MAX_HITS.to_s
  end

  # checks if the staff member with given tiss_id is a favourite of the current user
  def is_favourite(tiss_id)
    current_user.staff_favourites.each do |f|
      return true if f["staff_id"] == tiss_id
    end
    return false
  end

  # helper method used to get the (persisted) data of a users staff favourite
  def get_favourite_data(tiss_id)
    current_user.staff_favourites.each do |f|
      return f if f["staff_id"] == tiss_id
    end
    return nil
  end

  # helper for displaying the name of a favourite given the database id of it
  def get_fav_name(fav_id)
    ret = "Name not found"
    @favourites["objects"].each do |f|
      if f["fav_id"] == fav_id
        ret = f["first_name"] + " " + f["last_name"]
      end
    end
    ret
  end


  # Strong typing for edit form
  def favourite_params
    params.require(:staff_favourite).permit(:notes, :keywords)
  end

  #test
  def get_fav_url()
    return staff_favourites_url(:p => 1)
  end

end
