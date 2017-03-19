class FoodAdditive < ActiveRecord::Base
  validates :name, :about, :category, :danger, presence: true


  def FoodAdditive.search_e query
    query = 'E' + query unless query.start_with? ("E")

    FoodAdditive.find_by! name: query
  end
end
