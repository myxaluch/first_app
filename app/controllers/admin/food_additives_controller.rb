class Admin::FoodAdditivesController < ApplicationController
  if Rails.env.development? || Rails.env.test?
    require 'dotenv'
    Dotenv.load
  end
  http_basic_authenticate_with name: ENV['ADMIN_LOGIN'], password: ENV['ADMIN_PASS'] unless Rails.env.development?
  layout 'admin'

  def index
    @food_additives = FoodAdditive.paginate(page: params[:page]).order(:name)
    @search_path = admin_search_path
  end

  def new
    @additive = FoodAdditive.new
  end

  def search
    if params[:value].empty?
      flash[:danger] = t('.missing_name')
      redirect_to admin_path
    else
      @query = params[:value].upcase
      @result = FoodAdditive.search_e @query
      redirect_to admin_food_additive_path(@result.id)
    end
  end

  def create
    if params[:auto]
      @additive = create_additive(params[:food_additive][:name].to_s)
    elsif params[:manual]
      @additive = FoodAdditive.new(additive_params)
    end
    if @additive.save
      flash[:success] = t('.save')
      redirect_to admin_food_additive_path(@additive.id)
    else
      flash[:danger] = t('.save_error')
      render :new
    end
    rescue OpenURI::HTTPError
      flash[:danger] = t('.not_found')
      redirect_to new_admin_food_additive_path
  end

  def show
    @additive = FoodAdditive.find(params[:id])
  end

  def update
    @additive = FoodAdditive.find(params[:id])
    if @additive.update_attributes(additive_params)
      flash[:success] = t('.update')
      redirect_to admin_food_additive_path(@additive.id)
    else
      flash[:danger] = t('.update_error')
      render :show
    end
  end

  def destroy
    additive = FoodAdditive.find!(params[:id])
    if additive.destroy
      flash[:success] =t('.delete')
      redirect_to admin_path
    else
      flash[:danger] = t('.delete_error')
      render :show
    end
  end

  private

  def additive_params
    params.require(:food_additive).permit(:name, :about, :category, :danger)
  end

  def create_additive(additive)
    FoodAdditiveService.call(additive)
  end
end
