class Wine < ActiveRecord::Base
  include Queryable

  #basic 'category' / color of wine
  enum category: {
    red: "red",
    white: "white",
    rose: "rose",
    orange: "orange"
  }
end