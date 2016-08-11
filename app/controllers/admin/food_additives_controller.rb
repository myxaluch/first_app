class Admin::FoodAdditivesController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "admin" unless Rails.env.development?
  layout 'admin'

  def index
    @rand = FoodAdditive.take
    @food_additives = FoodAdditive.paginate(page: params[:page])
  end

  def new
    @additive = FoodAdditive.new
  end

  def create
    @additive = FoodAdditive.new
    if @additive.save
      redirect_to @additive
    end
  end

  def show
    @additive = FoodAdditive.find(params[:id])
  end

  def update
  end

  def destroy
  end

end
