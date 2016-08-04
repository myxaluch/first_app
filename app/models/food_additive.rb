class FoodAdditive < ActiveRecord::Base
  validates :name, presence: true
  validates :about, presence: true
end
