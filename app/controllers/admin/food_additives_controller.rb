class Admin::FoodAdditivesController < ApplicationController
  if Rails.env.development? || Rails.env.test?
    require 'dotenv'
    Dotenv.load
  end
  http_basic_authenticate_with name: ENV['ADMIN_LOGIN'], password: ENV['ADMIN_PASS'] unless Rails.env.development?
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
      redirect_back(fallback_location: :index)
    else
      @query = params[:value].upcase
      @result = FoodAdditive.search_E @query
      redirect_to admin_food_additive_path(@result.id)
    end
  end

  def create
    if params[:auto]
      create_additive params[:food_additive][:name].to_s
    elsif params[:manual]
      @additive = FoodAdditive.new(additive_params)
    end
    if @additive.save
      flash[:success] = "Информация добавлена"
      redirect_to admin_food_additive_path(@additive.id)
    else
      flash[:danger] = "Проблема с сохранением"
      render :new
    end
    rescue OpenURI::HTTPError
      flash[:danger] = "Данной добавки не существует!"
      redirect_back(fallback_location: :new)
  end

  def show
    @additive = FoodAdditive.find(params[:id])
  end

  def update
    @additive = FoodAdditive.find(params[:id])
    if @additive.update_attributes(additive_params)
      flash[:success] = "Информация обновлена"
      redirect_to admin_path
    else
      render :show
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

  def create_additive(additive)
    FoodAdditiveService.call(additive)
  end
end
