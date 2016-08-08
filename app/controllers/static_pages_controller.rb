class StaticPagesController < ApplicationController
  def index
  end

  def search
    @query = params[:value].upcase
    @result = FoodAdditive.search_E @query
  end
end
