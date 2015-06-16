class SearchController < ApplicationController
  authorize_resource

  respond_to :html

  def search
    respond_with(@found_resources = Search.search(params[:search][:q], params[:search][:filter_option]))
  end
end
