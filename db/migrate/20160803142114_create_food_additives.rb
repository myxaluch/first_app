class CreateFoodAdditives < ActiveRecord::Migration
  def change
    create_table :food_additives do |t|
      t.string :name
      t.text :about

      t.timestamps null: false
    end
  end
end
