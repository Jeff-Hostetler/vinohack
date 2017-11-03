class Food < ActiveRecord::Base
  include Queryable

  #basic 'category' of food
  enum category: {
    veg: "veg",
    fruit: "fruit",
    meat: "meat",
    fish: "fish",
    starch: "starch",
    sauce: "sauce"
  }
end