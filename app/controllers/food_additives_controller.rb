class FoodAdditivesController < ApplicationController
  def index
    @first = FoodAdditive.first
  end


end
