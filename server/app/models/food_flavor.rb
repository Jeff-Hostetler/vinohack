class FoodFlavor < ActiveRecord::Base
  belongs_to :food
  belongs_to :flavor
end