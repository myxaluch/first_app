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
      @additive = FoodAdditive.new
      parse_data params[:food_additive][:name].to_s
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

    def parse_data(additive)
      begin
        doc = Nokogiri::HTML(open("http://prodobavki.com/dobavki/#{additive}.html"))
      rescue OpenURI::HTTPError => e
        flash[:danger] = "Данной добавки не существует!"
      else
        @additive.name = additive
        @additive.about = doc.css("div#info_content").first.content
        @additive.category = doc.css("table tr td span")[2].content
        if doc.css("div#legacy_badge div ul li")[2].content == "Россия — разрешена"
          @additive.danger = 0
        elsif doc.css("div#legacy_badge div ul li")[0].content == "Россия — запрещена"
          @additive.danger = 2
        else
          @additive.danger = 1
        end
        @additive.source = "http://prodobavki.com/dobavki/#{additive}.html"
      end
    end
  end
