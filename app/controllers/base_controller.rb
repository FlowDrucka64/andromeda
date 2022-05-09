# base functionality controller used for search/favourites/details in each of the 4 functionalities
class BaseController < ApplicationController

  # The search term is used in the TISS API pull
  def search
    @results = []
    unless params[:q].blank?
      @results = api_search(params[:q])
      # "calculation" of the results to display on the current page of the results
      @results["result_slice"] = @results["results"].slice(PAGE_ENTRY_COUNT * (params[:p].to_i - 1), PAGE_ENTRY_COUNT)
    end
    logger.debug @results
  end


  def favourites
  end

  # Showing details (api-fetched) given by id in params
  def detail
    @result = api_fetch(params[:id])
  end


  private




  ##############################################################################################
  #
  #     Fetch methods here
  #     Used for fetching a specific object from the TISS API identified by an id
  #
  # ############################################################################################

  # This needs to be overridden by every controller using api_fetch
  def fetch_url
  end

  # Parse as JSON per default - override if needed
  def fetch_parse(http_result)
    JSON.parse http_result.body
  end

  # bundle up information pulled from API with persisted information for given favourite
  # slices the first PAGE_ENTRY_COUNT objects and stores it in "slice" (for rendering of the first result page)
  # calculates how many pages are needed to show all results given PAGE_ENTRY_COUNT
  def load_favourite_bundle(favourites)
    fav_bundle = { "objects" => [], "slice" => [], "page_count" => -1 }
    favourites.each do |f|
      fav_bundle["objects"].push(create_fav_object(f))
    end
    fav_bundle["page_count"] = (fav_bundle["objects"].length.to_f / PAGE_ENTRY_COUNT).ceil.to_i #calculate how much pages are needed to display the favourites
    return fav_bundle
  end

  # Combines the API-fetched object with according persisted information
  def create_fav_object(favourite)
    obj = api_fetch(favourite.staff_id)
    obj["fav_id"] = favourite.id
    obj["notes"] = favourite.notes
    obj["keywords"] = favourite.keywords
    return obj
  end

  # Fetch a staff member with tiss_id from TISS API
  def api_fetch(id)
    url = fetch_url + id.to_s
    return Rails.cache.fetch(url, expires_in: 12.hours) do
      fetch_parse(Excon.get(url)) #executed on cache miss
    end
  end


  ##############################################################################################
  #
  #     Search methods here
  #     Used for searching in the TISS API with a given searchterm
  #
  # ############################################################################################

  #This needs to be overridden by every controller using api_search
  def search_url
  end

  #This needs to be overridden by every controller using api_search defining the search params used
  # such as max_treffer or count
  def search_params
  end

  def search_parse(http_result)
    JSON.parse http_result.body
  end

  # API pull to the tiss api for given searchterm with set search_params
  def api_search(search_term)
    url = search_url + search_term.to_s + search_params
    return Rails.cache.fetch(url, expires_in: 12.hours) do
      search_transform(search_parse(Excon.get(url)))#executed on cache miss
    end
  end



  # adds the information of the needed page_count to the object
  def search_transform(response)
    response["page_count"] = (response["results"].length.to_f / PAGE_ENTRY_COUNT).ceil.to_i #calculate how much result pages are needed
    return response
  end

end
