require "rails_helper"

describe Food do
  it_behaves_like("it is queryable by name and category")
end