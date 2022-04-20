class StaffController < SearchController

  def search
    @results = []
    if params[:q]
      @results = api_search(params[:q])
      @results["result_slice"] = @results["results"].slice(20 * (params[:p].to_i - 1), 20)
    end
  end

  private

  def api_search(search_term)
    #TODO: cache results?
    url = BASE_API_URL + STAFF_SEARCH_URI + search_term.to_s + "&max_treffer=60"
    response = Excon.get(url)
    return nil if response.status != 200
    return search_transform(JSON.parse response.body)
  end

  def search_transform(response)
    response["page_count"] = (response["results"].length / 20).to_f.ceil.to_i #calculate how much result pages are needed
    return response
  end

end
