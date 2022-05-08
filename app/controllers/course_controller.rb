# Controller used for all course functionalities (Search/Detail View/ Favourite Management)
# "extending" from the BaseController
class CourseController < BaseController

  def favourites
  end

  def detail
    @result = api_fetch(params[:id])
    if is_favourite(params[:id])
      #TODO: append favourite information here
    end

  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end




  helper_method :is_favourite # used for case distinction when rendering detail information

  private

  def is_favourite(id)
    false
  end

  # override of base_controller
  def fetch_url
    return BASE_API_URL + COURSE_FETCH_URI
  end

  # Fetch a staff member with tiss_id from TISS API
  def api_fetch(id)
    url = fetch_url + id.to_s
    logger.debug url
    return Rails.cache.fetch(url, expires_in: 12.hours) do
      Excon.get(url).body #executed on cache miss
    end
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
      logger.debug r
    end
    return response
  end

end
