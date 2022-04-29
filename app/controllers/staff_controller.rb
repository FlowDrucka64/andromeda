class StaffController < BaseController

  def search
    @results = []
    unless params[:q].blank?
      @results = api_search(params[:q])
      @results["result_slice"] = @results["results"].slice(PAGE_ENTRY_COUNT * (params[:p].to_i - 1), PAGE_ENTRY_COUNT)
    end
  end

  def detail
    @result = api_fetch(params[:id])
  end

  def favourites
    @favourites = load_favourite_bundle(current_user.staff_favourites)
    @favourites["slice"] = @favourites["objects"].slice(PAGE_ENTRY_COUNT * (params[:p].to_i - 1), PAGE_ENTRY_COUNT)
  end

  def create
    if params[:id]
      unless is_favourite(params[:id])
        current_user.staff_favourites.create(staff_id: params[:id], notes: "", keywords: "")
        flash[:notice] = "User " + params["name"].to_s + " added to favourites"
        redirect_back(fallback_location: staff_search_url)
      end
    end
  end

  def edit
    @favourites = load_favourite_bundle(current_user.staff_favourites)
    @favourite = current_user.staff_favourites.where(:id => params["id"].to_i)[0]
    @fav_name = get_fav_name(params["id"].to_i)
  end

  def update
    @favourite = current_user.staff_favourites.where(:id => params["id"].to_i)[0]
    if @favourite.update(favourite_params)
      flash[:notice] = "Updated"
    else
      flash[:notice] = "Error updating"
    end
    redirect_to staff_favourites_path(p: 1)
  end

  def destroy
    if params[:id]
      @favourite = current_user.staff_favourites.where(:id => params["id"].to_i)[0]
      @favourite.destroy
      flash[:notice] = "Deleted"
      redirect_to staff_favourites_path(p: 1)
    end
  end

  helper_method :is_favourite #used for case distinction when rendering detail information
  helper_method :get_favourite_data #used for rendering detail information

  private

  #checks if the staff member with given tiss_id is a favourite of the current user
  def is_favourite(tiss_id)
    current_user.staff_favourites.each do |f|
      return true if f["staff_id"] == tiss_id
    end
    return false
  end

  #helper method used to get the (persisted) data of a users staff favourite
  def get_favourite_data(tiss_id)
    current_user.staff_favourites.each do |f|
      return f if f["staff_id"] == tiss_id
    end
    return nil
  end

  #API pull to the tiss api for given searchterm with max_treffer= MAX_HITS
  def api_search(search_term)
    url = BASE_API_URL + STAFF_SEARCH_URI + search_term.to_s + "&max_treffer=" + MAX_HITS.to_s
    return Rails.cache.fetch(search_term, expires_in: 12.hours) do
      search_transform(JSON.parse Excon.get(url).body) #executed on cache miss
    end
  end

  #adds the information of the needed page_count to the object
  def search_transform(response)
    response["page_count"] = (response["results"].length.to_f / PAGE_ENTRY_COUNT).ceil.to_i #calculate how much result pages are needed
    return response
  end

  #bundle up information pulled from API with persisted information for given favourite
  #slices the first PAGE_ENTRY_COUNT objects and stores it in "slice" (for rendering of the first result page)
  #calculates how many pages are needed to show all results given PAGE_ENTRY_COUNT
  def load_favourite_bundle(favourites)
    fav_bundle = { "objects" => [], "slice" => [], "page_count" => -1 }
    favourites.each do |f|
      fav_bundle["objects"].push(create_fav_object(f))
    end
    fav_bundle["page_count"] = (fav_bundle["objects"].length.to_f / PAGE_ENTRY_COUNT).ceil.to_i
    return fav_bundle
  end

  #Adds information to an (API-fetched) object from persisted information
  def create_fav_object(favourite)
    obj = api_fetch(favourite.staff_id)
    obj["fav_id"] = favourite.id
    obj["notes"] = favourite.notes
    obj["keywords"] = favourite.keywords
    return obj
  end

  #Fetch a staff member with tiss_id from TISS API
  def api_fetch(tiss_id)
    url = BASE_API_URL + STAFF_FETCH_URI + tiss_id.to_s
    return Rails.cache.fetch(tiss_id, expires_in: 12.hours) do
      JSON.parse Excon.get(url).body #executed on cache miss
    end
  end

  #strong typing for edit form
  def favourite_params
    params.require(:staff_favourite).permit(:notes, :keywords)
  end

  #helper for displaying the name of a favourite given the database id of it
  def get_fav_name(fav_id)
    ret = "Name not found"
    @favourites["objects"].each do |f|
      if f["fav_id"] == fav_id
        ret = f["first_name"] + " " + f["last_name"]
      end
    end
    ret
  end

end
