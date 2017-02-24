class StaticPagesController < ApplicationController
  def index
    @search_path = "/search"
  end

  def search
    if params[:value].empty?
      flash[:danger] = "Пожалуйста, введите название добавки"
      redirect_to :back
    else
      @query = params[:value].upcase
      @result = FoodAdditive.search_E @query
    end
  end
end
