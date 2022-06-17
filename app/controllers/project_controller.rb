# Controller used for all project functionalities (Search/Detail View/ Favourite Management)
# "extending" from the BaseController
class ProjectController < BaseController

  # display of the users' favourites
  def favourites
    @favourites = load_favourite_bundle(current_user.project_favourites)
    # "calculation" of the results to display on the current page of the results
    @favourites["slice"] = @favourites["objects"].slice(PAGE_ENTRY_COUNT * (params[:p].to_i - 1), PAGE_ENTRY_COUNT)
  end

  # Creating new favourite (persisting to db)
  def create
    if params[:id]
      unless is_favourite(params[:id])
        current_user.project_favourites.create(project_id: params[:id], notes: "", keywords: "")
        flash[:notice] = "Project " + params["title"].to_s + " added to favourites"
        redirect_back(fallback_location: project_search_url)
      end
    end
  end

  # Displays an edit form for a favourite given by the id in params
  def edit
    @favourites = load_favourite_bundle(current_user.project_favourites)
    @favourite = current_user.project_favourites.where(:id => params["id"].to_i)[0]
    @fav_name = get_fav_name(params["id"].to_i)
  end

  # Update fields of a project-favourite given by id in params
  # This is where the data from the edit form is posted to and processed
  def update
    @favourite = current_user.project_favourites.where(:id => params["id"].to_i)[0]
    if @favourite.update(favourite_params)
      flash[:notice] = "Updated"
    else
      flash[:notice] = "Error updating"
    end
    redirect_to project_favourites_path(p: 1)
  end

  # removing a favourite
  def destroy
    if params[:id]
      @favourite = current_user.project_favourites.where(:id => params["id"].to_i)[0]
      @favourite.destroy
      flash[:notice] = "Deleted"
      redirect_to project_favourites_path(p: 1)
    end
  end

  # print functionality to provide a printable list of all favourites
  def print
    @favourites = load_favourite_bundle(current_user.project_favourites)['objects']
  end

  helper_method :is_favourite # used for case distinction when rendering detail information
  helper_method :get_favourite_data # used for rendering detail information
  helper_method :get_fav_url # override from base since the url is different for each controller, needed for sorting

  private


  # ############################################################################################
  #
  #     Helper methods here
  #     Helpers used for displaying data in the HTML
  #
  # ############################################################################################

  # checks if the project with given id is a favourite of the current user
  def is_favourite(id)
    current_user.project_favourites.each do |f|
      return true if f["project_id"].to_s == id.to_s
    end
    return false
  end

  # helper method used to get the (persisted) data of a users project favourite
  def get_favourite_data(id)
    current_user.project_favourites.each do |f|
      return f if f["project_id"].to_s == id.to_s
    end
    return nil
  end

  # override from base since the url is different for each controller
  # this is needed in order to do all sorting in a single "master" partial (_favourites.html.erb)
  def get_fav_url
    return project_favourites_url(:p => 1)
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

  # ############################################################################################
  #
  #     DB and API pull methods here
  #     These methods are used for getting the data from the API and the DB
  #     and formatting it so that it can be presented in the HTML
  #
  # ############################################################################################

  # override of base_controller
  def fetch_url
    return BASE_API_URL + PROJECT_FETCH_URI
  end

  # override of base_controller
  def search_url
    return BASE_API_URL + PROJECT_SEARCH_URI
  end

  def search_params
    "&max_treffer=" + MAX_HITS.to_s
  end

  # override of base_controller since results are XMLs
  def fetch_parse(http_result)
    return Hash.from_xml(http_result.body.to_s)["tuVienna"]["project"]
  end

  # creates an object containing all the (persisted) information of a favourite project
  # combined with the available API data
  # used in load_favourite_bundle (defined in base_controller)
  def create_fav_object(favourite)
    obj = api_fetch(favourite.project_id)
    obj["fav_id"] = favourite.id
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

  # ############################################################################################
  #
  #     Typing methods here
  #     These methods are used for strong typing of user input data
  #
  # ############################################################################################

  # Strong typing for edit form
  def favourite_params
    params.require(:project_favourite).permit(:notes, :keywords)
  end

end
