class StaffController < BaseController

  def search
    @results = []
    unless params[:q].blank?
      @results = api_search(params[:q])
      @results["result_slice"] = @results["results"].slice(PAGE_ENTRY_COUNT * (params[:p].to_i - 1), PAGE_ENTRY_COUNT)
    end
  end

  def detail
    @result = api_detail(params[:id])
  end

  def favourites
    @favourites = load_favourite_bundle(current_user.staff_favourites)
    @favourites["slice"] = @favourites["objects"].slice(PAGE_ENTRY_COUNT * (params[:p].to_i - 1), PAGE_ENTRY_COUNT)
  end

  private

  def api_search(search_term)
    url = BASE_API_URL + STAFF_SEARCH_URI + search_term.to_s + "&max_treffer=" + MAX_HITS.to_s
    return Rails.cache.fetch(search_term, expires_in: 12.hours) do
      search_transform(JSON.parse Excon.get(url).body) #executed on cache miss
    end
  end

  def api_detail(id)
    url = BASE_API_URL + STAFF_DETAIL_URI + id.to_s
    return JSON.parse Excon.get(url).body
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
    obj["notes"] = favourite.notes
    obj["keywords"] = favourite.keywords
    return obj
  end

  def api_fetch(staff_id)
    url = BASE_API_URL + STAFF_FETCH_URI + staff_id.to_s
    return Rails.cache.fetch(staff_id, expires_in: 12.hours) do
      JSON.parse Excon.get(url).body #executed on cache miss
    end
  end

end
