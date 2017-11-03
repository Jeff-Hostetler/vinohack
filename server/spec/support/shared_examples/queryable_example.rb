shared_examples "it is queryable by name and category" do
  let!(:allowed_categories) { described_class.categories.values}
  let!(:first_record) { described_class.create(name: "first", category: allowed_categories[0]) }
  let!(:second_record) { described_class.create(name: "second", category: allowed_categories[1]) }

  describe ".filtered_with_params" do
    it "can return all" do
      result = described_class.filtered_with_params({})

      expect(result).to match_array([first_record, second_record])
    end

    it "can filter by name" do
      result = described_class.filtered_with_params({ name: "iRs" })

      expect(result).to match_array([first_record])
    end

    it "can filter by category" do
      result = described_class.filtered_with_params({ category: allowed_categories[0] })

      expect(result).to match_array([first_record])
    end
  end
end