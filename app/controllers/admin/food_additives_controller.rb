class Admin::FoodAdditivesController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "admin" unless Rails.env.development?
  layout 'admin'

  def index
    @food_additives = FoodAdditive.paginate(page: params[:page]).order(:name)
    @search_path = "/admin/search"
  end

  def new
    @additive = FoodAdditive.new
  end

  def search
    if params[:value].empty?
      flash[:danger] = "Пожалуйста, введите название добавки"
      redirect_to :back
    else
      @query = params[:value].upcase
      @result = FoodAdditive.search_E @query
      redirect_to admin_food_additive_path(@result.id)
    end
  end

  def create
    @additive = FoodAdditive.new(additive_params)
    if @additive.save
      flash[:success] = "Информация добавлена"
      redirect_to admin_food_additive_path(@additive.id)
    else
      render 'new'
    end
  end

  def download
    if params[:source]
      flash[:danger] = "Пожалуйста, введите адрес"
      redirect_to :back
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
      params.require(:food_additive).permit(:name, :about, :category, :danger)
    end

end
