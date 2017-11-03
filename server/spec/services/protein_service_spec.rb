require "rails_helper"

describe ProteinService do
  describe "#get_protein" do
    before do
      @meat = Food.create!(category: "meat")
      @fish = Food.create!(category: "fish")
      @veg = Food.create!(category: "veg")
    end

    it "return nil if no foods are a protein" do
      expect(subject.get_protein(Food.where(id: [@veg.id]))).to eq(nil)
    end

    it "returns a meat food if it is in the list" do
      expect(subject.get_protein(Food.where(id: [@veg.id, @fish.id, @meat.id]))).to eq(@meat)
    end

    it "returns a fish food if it is in the list and a meat food is not" do
      expect(subject.get_protein(Food.where(id: [@veg.id, @fish.id]))).to eq(@fish)
    end
  end
end