class AddDetailsToFoodAdditives < ActiveRecord::Migration[5.0]
  def change
    add_column :food_additives, :source, :string
    add_column :food_additives, :danger, :integer
    add_column :food_additives, :category, :string
  end
end
