class Admin::FoodAdditivesController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "admin" unless Rails.env.development?
  layout 'admin'

  def index
    @rand = FoodAdditive.take
    @food_additives = FoodAdditive.paginate(page: params[:page]).order(:name)
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
    @additive = FoodAdditive.find(params[:id])
    if @additive.update_attributes(additive_params)
      flash[:success] = "Информация обновлена"
      redirect_to admin_food_additive_path(@additive.id)
    else
      render 'show'
    end
  end

  def destroy
    FoodAdditive.find(params[:id]).destroy
    flash[:success] = "Информация удалена"
    redirect_to admin_path
  end


    private

    def additive_params
      params.require(:food_additive).permit(:name, :about)
    end

end
