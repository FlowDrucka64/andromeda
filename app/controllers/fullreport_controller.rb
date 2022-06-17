class FullreportController < BaseController

  # method to display the fullreport of a given lecturer
  def show
    @person = api_fetch(params[:id])
    @courses = course_fetch(@person["oid"])["course"]
    @projects = project_detail_fetch_all(I18n.transliterate(@person["last_name"]) + " " + I18n.transliterate(@person["first_name"]))
    @thesis = thesis_detail_fetch_all(I18n.transliterate(@person["last_name"]) + " " + I18n.transliterate(@person["first_name"]))
  end

  helper_method :staff_is_favourite # used for case distinction when rendering detail information
  helper_method :staff_get_favourite_data # used for rendering detail information

  helper_method :format_course_number # formatting the course number so it's seperated by a .
  helper_method :course_is_favourite # used for case distinction when rendering detail information
  helper_method :course_get_favourite_data # used for rendering detail information

  helper_method :project_is_favourite # used for case distinction when rendering detail information
  helper_method :project_get_favourite_data # used for rendering detail information

  helper_method :thesis_is_favourite # used for case distinction when rendering detail information
  helper_method :thesis_get_favourite_data # used for rendering detail information

  private

  # ############################################################################################
  #
  #     Course stuff
  #     fetching course data related to a specific lecturer
  #
  # ############################################################################################

  # Fetch all courses associated with a given lecturer id
  def course_fetch(lecturer_id)
    url = BASE_API_URL+COURSE_SEARCH_BY_LECTURER_URI+lecturer_id.to_s
    return Rails.cache.fetch(url, expires_in: 12.hours) do
      (Hash.from_xml(Excon.get(url).body.to_s)["tuvienna"])#executed on cache miss
    end
  end

  # ############################################################################################
  #
  #     Project stuff
  #     Fetching project data related to a specific lecturer
  #
  # ############################################################################################

  # search for all projects associated with lecturer_name first
  # then fetch all the detail information for those and combine them into a list
  def project_detail_fetch_all(lecturer_name)
    projects = project_search(lecturer_name)["results"]
    ret = []
    projects.each do |f|
      ret.push(project_detail_fetch(f["id"]))
    end
    return ret
  end

  # search for all projects associated with a given lecturer_name
  def project_search(lecturer_name)
    url = BASE_API_URL+PROJECT_SEARCH_URI+lecturer_name
    logger.info(url)
    return Rails.cache.fetch(url, expires_in: 12.hours) do
      JSON.parse(Excon.get(url).body)#executed on cache miss
    end
  end

  # fetch detail data for a given project id
  def project_detail_fetch(id)
    url = BASE_API_URL + PROJECT_FETCH_URI+  id.to_s
    return Rails.cache.fetch(url, expires_in: 12.hours) do
      Hash.from_xml(Excon.get(url).body.to_s)["tuVienna"]["project"] #executed on cache miss
    end
  end

  # ############################################################################################
  #
  #     Thesis stuff
  #     Fetching thesis data related to a specific lecturer
  #
  # ############################################################################################

  # search for all thesis associated with lecturer_name first
  # then fetch all the detail information for those and combine them into a list
  def thesis_detail_fetch_all(lecturer_name)
    thesis = thesis_search(lecturer_name)["results"]
    ret = []
    thesis.each do |f|
      ret.push(thesis_detail_fetch(f["id"]))
    end
    return ret
  end

  # search for all projects associated with a given lecturer_name
  def thesis_search(lecturer_name)
    url = BASE_API_URL+THESIS_SEARCH_URI+lecturer_name
    logger.info(url)
    return Rails.cache.fetch(url, expires_in: 12.hours) do
      JSON.parse(Excon.get(url).body)#executed on cache miss
    end
  end

  # fetch detail data for a given thesis id
  def thesis_detail_fetch(id)
    url = BASE_API_URL+THESIS_FETCH_URI+id.to_s
    logger.info(url)
    return Rails.cache.fetch(url, expires_in: 12.hours) do
      (Hash.from_xml(Excon.get(url).body.to_s)["tuvienna"]["thesis"])#executed on cache miss
    end
  end

  # ############################################################################################
  #
  #     Staff stuff
  #     Fetching staff data related to a specific lecturer
  #
  # ############################################################################################


  # override of base_controller
  def fetch_url
    return BASE_API_URL + STAFF_FETCH_URI
  end

  # override of base_controller
  def search_url
    return BASE_API_URL + STAFF_SEARCH_URI
  end

  # override of base_controller
  def search_params
    "&max_treffer=" + MAX_HITS.to_s
  end

  # formatting the course number so it's seperated by a .
  def format_course_number(course_number)
    return course_number.dup.insert(3,".")
  end

  # ############################################################################################
  #
  #     Database stuff
  #     Checking if a given course/thesis/project is a favourite and
  #     pulling persisted data for favourites from the DB
  #
  # ############################################################################################

  # checks if the staff member with given tiss_id is a favourite of the current user
  def staff_is_favourite(tiss_id)
    current_user.staff_favourites.each do |f|
      return true if f["staff_id"] == tiss_id
    end
    return false
  end

  # checks if a given course id is within the favourites of the current user
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
