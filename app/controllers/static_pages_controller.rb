class StaticPagesController < ApplicationController
  def index
    @rand = FoodAdditive.take
  end

  def search
    if params[:value].empty?
      flash[:danger] = "Пожалуйста, введите название добавки"
      redirect_to root_url
    else
      @query = params[:value].upcase
      @result = FoodAdditive.search_E @query
    end
  end


end
