require "rails_helper"

describe Queryable do
  describe ".filtered_with_params" do
    class Dummy
      include Queryable
      def self.all
      end
    end

    before do
      @all_dummies = double(where: [])
      allow(Dummy).to receive(:all).and_return(@all_dummies)
    end

    it "can return all" do
      Dummy.filtered_with_params({})

      expect(Dummy).to have_received(:all)
      expect(@all_dummies).to_not have_received(:where)
    end

    it "can filter by name" do
      Dummy.filtered_with_params({ name: "name" })

      expect(Dummy).to have_received(:all)
      expect(@all_dummies).to have_received(:where).with("name ILIKE ?", "%name%")
    end

    it "can filter by category" do
      Dummy.filtered_with_params({ category: "cat" })

      expect(Dummy).to have_received(:all)
      expect(@all_dummies).to have_received(:where).with({:category=>"cat"})
    end
  end
end