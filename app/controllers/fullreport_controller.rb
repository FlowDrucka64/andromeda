class FullreportController < BaseController

  def show
    @person = api_fetch(params[:id])
    @courses = course_fetch(@person["oid"])["course"]
    @projects = project_detail_fetch_all(@person["last_name"])
    @thesis = thesis_detail_fetch_all(@person["last_name"])
  end

  helper_method :staff_is_favourite # used for case distinction when rendering detail information
  helper_method :staff_get_favourite_data # used for rendering detail information

  helper_method :format_course_number
  helper_method :course_is_favourite # used for case distinction when rendering detail information
  helper_method :course_get_favourite_data # used for rendering detail information

  helper_method :project_is_favourite # used for case distinction when rendering detail information
  helper_method :project_get_favourite_data # used for rendering detail information

  helper_method :thesis_is_favourite # used for case distinction when rendering detail information
  helper_method :thesis_get_favourite_data # used for rendering detail information

  private

  #------------------------------------Course stuff-----------------------------------------------------

  def course_fetch(lecturer_id)
    url = BASE_API_URL+COURSE_SEARCH_BY_LECTURER_URI+lecturer_id.to_s
    logger.info(url)
    return Rails.cache.fetch(url, expires_in: 12.hours) do
      (Hash.from_xml(Excon.get(url).body.to_s)["tuvienna"])#executed on cache miss
    end
  end

  #------------------------------------Project stuff-----------------------------------------------------
  def project_detail_fetch_all(lecturer_name)
    projects = project_search(lecturer_name)["results"]
    ret = []
    projects.each do |f|
      ret.push(project_detail_fetch(f["id"]))
    end
    return ret
  end


  def project_search(lecturer_name)
    url = BASE_API_URL+PROJECT_SEARCH_URI+lecturer_name
    logger.info(url)
    return Rails.cache.fetch(url, expires_in: 12.hours) do
      JSON.parse(Excon.get(url).body)#executed on cache miss
    end
  end

  def project_detail_fetch(id)
    url = BASE_API_URL + PROJECT_FETCH_URI+  id.to_s
    return Rails.cache.fetch(url, expires_in: 12.hours) do
      Hash.from_xml(Excon.get(url).body.to_s)["tuVienna"]["project"] #executed on cache miss
    end
  end


  #------------------------------------Thesis stuff-----------------------------------------------------
  def thesis_detail_fetch_all(lecturer_name)
    thesis = thesis_search(lecturer_name)["results"]
    ret = []
    thesis.each do |f|
      ret.push(thesis_detail_fetch(f["id"]))
    end
    return ret
  end

  def thesis_search(lecturer_name)
    url = BASE_API_URL+THESIS_SEARCH_URI+lecturer_name
    logger.info(url)
    return Rails.cache.fetch(url, expires_in: 12.hours) do
      JSON.parse(Excon.get(url).body)#executed on cache miss
    end
  end

  def thesis_detail_fetch(id)
    url = BASE_API_URL+THESIS_FETCH_URI+id.to_s
    logger.info(url)
    return Rails.cache.fetch(url, expires_in: 12.hours) do
      (Hash.from_xml(Excon.get(url).body.to_s)["tuvienna"]["thesis"])#executed on cache miss
    end
  end

  #------------------------------------Staff stuff-----------------------------------------------------
  # override of base_controller
  def fetch_url
    return BASE_API_URL + STAFF_FETCH_URI
  end

  def format_course_number(course_number)
    return course_number.dup.insert(3,".")
  end

  # override of base_controller
  def search_url
    return BASE_API_URL + STAFF_SEARCH_URI
  end

  def search_params
    "&max_treffer=" + MAX_HITS.to_s
  end

  #------------------------------------Database stuff-----------------------------------------------------

  # checks if the staff member with given tiss_id is a favourite of the current user
  def staff_is_favourite(tiss_id)
    current_user.staff_favourites.each do |f|
      return true if f["staff_id"] == tiss_id
    end
    return false
  end

  def course_is_favourite(id)
    current_user.course_favourites.each do |f|
      return true if f["course_number"].to_s+"-"+f["semester"] == id
    end
    return false
  end

  # checks if the project with given id is a favourite of the current user
  def project_is_favourite(id)
    current_user.project_favourites.each do |f|
      return true if f["project_id"].to_s == id.to_s
    end
    return false
  end

  # checks if the thesis with given id is a favourite of the current user
  def thesis_is_favourite(id)
    current_user.thesis_favourites.each do |f|
      return true if f["thesis_id"].to_s == id.to_s
    end
    return false
  end

  # helper method used to get the (persisted) data of a users staff favourite
  def staff_get_favourite_data(tiss_id)
    current_user.staff_favourites.each do |f|
      return f if f["staff_id"] == tiss_id
    end
    return nil
  end

  # helper method used to get the (persisted) data of a users staff favourite
  def course_get_favourite_data(id)
    current_user.course_favourites.each do |f|
      return f if f["course_number"].to_s+"-"+f["semester"] == id
    end
    return nil
  end

  # helper method used to get the (persisted) data of a users project favourite
  def project_get_favourite_data(id)
    current_user.project_favourites.each do |f|
      return f if f["project_id"].to_s == id.to_s
    end
    return nil
  end

  # helper method used to get the (persisted) data of a users thesis favourite
  def thesis_get_favourite_data(id)
    current_user.thesis_favourites.each do |f|
      return f if f["thesis_id"].to_s == id.to_s
    end
    return nil
  end

end
