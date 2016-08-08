class FoodAdditive < ActiveRecord::Base
  validates :name, presence: true
  validates :about, presence: true

  def FoodAdditive.search_E query
    unless query.start_with? ("E")
      query = 'E' + query
    end
    FoodAdditive.find_by! name: query
  end

end
