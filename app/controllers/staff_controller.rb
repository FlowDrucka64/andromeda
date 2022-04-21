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
    response["page_count"] = (response["results"].length / PAGE_ENTRY_COUNT).to_f.ceil.to_i #calculate how much result pages are needed
    return response
  end


end
