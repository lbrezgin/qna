class SearchesController < ApplicationController
  skip_authorization_check

  def search
    @query = params[:query]
    @resource = params[:resource]

    @resources = SearchForResource.search_for(@query, @resource)
  end
end

