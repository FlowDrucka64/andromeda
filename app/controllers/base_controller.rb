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
  end


  def favourites
  end

  # Showing details (api-fetched) given by id in params
  def detail
    @result = api_fetch(params[:id])
  end


  private

  def api_search(search_term)
    []
  end

  def api_fetch(tiss_id)
  end
end
