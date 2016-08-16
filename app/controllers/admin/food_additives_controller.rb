class Admin::FoodAdditivesController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
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
    if params[:auto]
      h1 = parse_data params[:food_additive][:source].to_s
      render plain: h1
    elsif params[:manual]
      @additive = FoodAdditive.new(additive_params)
    end
    if @additive.save
      flash[:success] = "Информация добавлена"
      redirect_to admin_food_additive_path(@additive.id)
    else
      render 'new'
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

    def parse_data(url)
      doc = Nokogiri::HTML(open(url))
      h1 = doc.xpath("//h1").first.content
    end

end
