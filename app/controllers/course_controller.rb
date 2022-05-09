# Controller used for all course functionalities (Search/Detail View/ Favourite Management)
# "extending" from the BaseController
class CourseController < BaseController

  def favourites
    @favourites = load_favourite_bundle(current_user.course_favourites)
    # "calculation" of the results to display on the current page of the results
    @favourites["slice"] = @favourites["objects"].slice(PAGE_ENTRY_COUNT * (params[:p].to_i - 1), PAGE_ENTRY_COUNT)
  end

  def detail
    @result = api_fetch(params[:id])
  end

  def create
    if params[:course_number] && params[:semester]
      unless is_favourite(params[:id])
        current_user.course_favourites.create(course_number: params[:course_number], semester:params[:semester], notes: "", keywords: "")
        flash[:notice] = "Course " + params["title"].to_s + " added to favourites"
        redirect_back(fallback_location: course_search_url)
      end
    end
  end

  def edit
    @favourites = load_favourite_bundle(current_user.course_favourites)
    @favourite = current_user.course_favourites.where(:id=> params["id"].to_i)[0]
    @fav_name = get_fav_name(params["id"].to_i)
  end

  def update
    @favourite = current_user.course_favourites.where(:id => params["id"].to_i)[0]
    if @favourite.update(favourite_params)
      flash[:notice] = "Updated"
    else
      flash[:notice] = "Error updating"
    end
    redirect_to course_favourites_path(p: 1)
  end

  def destroy
    if params[:id]
      @favourite = current_user.course_favourites.where(:id => params["id"].to_i)[0]
      @favourite.destroy
      flash[:notice] = "Deleted"
      redirect_to course_favourites_path(p: 1)
    end
  end




  helper_method :is_favourite # used for case distinction when rendering detail information
  helper_method :get_favourite_data
  helper_method :format_course_number
  helper_method :get_name

  private

  def format_course_number(course_number)
    return course_number.dup.insert(3,".")
  end

  def is_favourite(id)
    current_user.course_favourites.each do |f|
      return true if f["course_number"].to_s+"-"+f["semester"] == id
    end
    return false
  end

  # helper method used to get the (persisted) data of a users staff favourite
  def get_favourite_data(id)
    current_user.course_favourites.each do |f|
      return f if f["course_number"].to_s+"-"+f["semester"] == id
    end
    return nil
  end

  def get_fav_name(id)
    ret = "Name not found"
    @favourites["objects"].each do |f|
      if f["fav_id"] == id
        ret = f["title"]["en"]
      end
    end
    ret
  end

  def get_name(id)
    obj = api_fetch(id)
    return format_course_number(obj["courseNumber"])+" "+obj["title"]["en"] + ", "+obj["semesterCode"]
  end

  # override of base_controller
  def fetch_url
    return BASE_API_URL + COURSE_FETCH_URI
  end

  # override of base_controller
  def fetch_parse(http_result)
    return Hash.from_xml(http_result.body.to_s)["tuvienna"]["course"]
  end

  def create_fav_object(favourite)
    obj = api_fetch(favourite.course_number.to_s+"-"+favourite.semester)
    obj["fav_id"] = favourite.id
    obj["notes"] = favourite.notes
    obj["keywords"] = favourite.keywords
    return obj
  end



  # override of base_controller
  def search_url
    return BASE_API_URL + COURSE_SEARCH_URI
  end

  def search_params
    "&count="+MAX_HITS.to_s
  end

  def search_transform(response)
    response["page_count"] = (response["results"].length.to_f / PAGE_ENTRY_COUNT).ceil.to_i #calculate how much result pages are needed
    response["results"].each do |r|
      tmp = r["detail_url"].slice(r["detail_url"].index("?")+1..r["detail_url"].length)
      params = Rack::Utils.parse_nested_query(tmp)
      r["course_number"] = params["courseNr"]
      r["semester"] = params["semester"]
    end
    return response
  end

  def favourite_params
    params.require(:course_favourite).permit(:notes, :keywords)
  end

end
