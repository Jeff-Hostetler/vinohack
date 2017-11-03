require "rails_helper"

describe Wine do
  it_behaves_like("it is queryable by name and category")
end