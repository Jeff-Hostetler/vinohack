class CreateFoodFlavors < ActiveRecord::Migration[5.1]
  def change
    create_table :food_flavors do |t|
      t.belongs_to :food
      t.belongs_to :flavor

      t.timestamps
    end
  end
end
