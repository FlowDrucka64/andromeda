# Controller used for all thesis functionalities (Search/Detail View/ Favourite Management)
# "extending" from the BaseController
class ThesisController < BaseController

  def favourites
    @favourites = load_favourite_bundle(current_user.thesis_favourites)
    # "calculation" of the results to display on the current page of the results
    @favourites["slice"] = @favourites["objects"].slice(PAGE_ENTRY_COUNT * (params[:p].to_i - 1), PAGE_ENTRY_COUNT)
  end

  def detail
    @result = api_fetch(params[:id])
  end

  def create
    if params[:id]
      unless is_favourite(params[:id])
        current_user.thesis_favourites.create(thesis_id: params[:id], notes: "", keywords: "")
        flash[:notice] = "Thesis " + params["title"].to_s + " added to favourites"
        redirect_back(fallback_location: thesis_search_url)
      end
    end
  end

  def edit
    @favourites = load_favourite_bundle(current_user.thesis_favourites)
    @favourite = current_user.thesis_favourites.where(:id => params["id"].to_i)[0]
    @fav_name = get_fav_name(params["id"].to_i)
  end

  def update
    @favourite = current_user.thesis_favourites.where(:id => params["id"].to_i)[0]
    if @favourite.update(favourite_params)
      flash[:notice] = "Updated"
    else
      flash[:notice] = "Error updating"
    end
    redirect_to thesis_favourites_path(p: 1)
  end

  def destroy
    if params[:id]
      @favourite = current_user.thesis_favourites.where(:id => params["id"].to_i)[0]
      @favourite.destroy
      flash[:notice] = "Deleted"
      redirect_to thesis_favourites_path(p: 1)
    end
  end

  def print
    render :layout => false
    @favourites = load_favourite_bundle(current_user.thesis_favourites)
  end

  helper_method :is_favourite # used for case distinction when rendering detail information
  helper_method :get_favourite_data # used for rendering detail information
  helper_method :get_fav_url

  private

  # override of base_controller
  def fetch_url
    return BASE_API_URL + THESIS_FETCH_URI
  end

  # override of base_controller
  def search_url
    return BASE_API_URL + THESIS_SEARCH_URI
  end

  def search_params
    "&max_treffer=" + MAX_HITS.to_s
  end

  # checks if the thesis with given id is a favourite of the current user
  def is_favourite(id)
    current_user.thesis_favourites.each do |f|
      return true if f["thesis_id"].to_s == id.to_s
    end
    return false
  end

  # helper method used to get the (persisted) data of a users thesis favourite
  def get_favourite_data(id)
    current_user.thesis_favourites.each do |f|
      return f if f["thesis_id"].to_s == id.to_s
    end
    return nil
  end

  # helper for displaying the name of a favourite given the database id of it
  def get_fav_name(fav_id)
    ret = "Name not found"
    @favourites["objects"].each do |f|
      if f["fav_id"] == fav_id
        ret = f["title"]
      end
    end
    ret
  end

  def create_fav_object(favourite)
    obj = api_fetch(favourite.thesis_id)
    obj["fav_id"] = favourite.id
    obj["id"] = favourite.thesis_id
    obj["notes"] = favourite.notes
    obj["keywords"] = favourite.keywords
    obj["date"] = favourite["created_at"]
    if obj["title"]["en"].nil?
      obj["sort_title"] = obj["title"]["de"]
    else
      obj["sort_title"] = obj["title"]["en"]
    end
    return obj
  end

  # override of base_controller
  def fetch_parse(http_result)
    return Hash.from_xml(http_result.body.to_s)["tuvienna"]["thesis"]
  end

  # Strong typing for edit form
  def favourite_params
    params.require(:thesis_favourite).permit(:notes, :keywords)
  end

  #test
  def get_fav_url()
    return thesis_favourites_url(:p => 1)
  end
end
