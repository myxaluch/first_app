class StaticPagesController < ApplicationController
  def index
  end

  def search
    @result = FoodAdditive.find_by! name: params[:value].upcase
  end
end
