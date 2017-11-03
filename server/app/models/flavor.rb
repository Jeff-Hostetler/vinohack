class Flavor < ActiveRecord::Base
  has_many :food_flavors
end