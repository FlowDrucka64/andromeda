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

  helper_method :is_favourite

  private

  def is_favourite(tiss_id)
    current_user.staff_favourites.each do |f|
      return true if f["staff_id"] == tiss_id
    end
    return false
  end

  def api_search(search_term)
    url = BASE_API_URL + STAFF_SEARCH_URI + search_term.to_s + "&max_treffer=" + MAX_HITS.to_s
    return Rails.cache.fetch(search_term, expires_in: 12.hours) do
      search_transform(JSON.parse Excon.get(url).body) #executed on cache miss
    end
  end

  def search_transform(response)
    response["page_count"] = (response["results"].length.to_f / PAGE_ENTRY_COUNT).ceil.to_i #calculate how much result pages are needed
    return response
  end

  def load_favourite_bundle(favourites)
    fav_bundle = { "objects" => [], "slice" => [], "page_count" => -1 }
    favourites.each do |f|
      fav_bundle["objects"].push(create_fav_object(f))
    end
    fav_bundle["page_count"] = (fav_bundle["objects"].length.to_f / PAGE_ENTRY_COUNT).ceil.to_i
    return fav_bundle
  end

  def create_fav_object(favourite)
    obj = api_fetch(favourite.staff_id)
    obj["fav_id"] = favourite.id
    obj["notes"] = favourite.notes
    obj["keywords"] = favourite.keywords
    return obj
  end

  def api_fetch(tiss_id)
    url = BASE_API_URL + STAFF_FETCH_URI + tiss_id.to_s
    return Rails.cache.fetch(tiss_id, expires_in: 12.hours) do
      JSON.parse Excon.get(url).body #executed on cache miss
    end
  end

  def favourite_params
    params.require(:staff_favourite).permit(:notes, :keywords)
  end

end
