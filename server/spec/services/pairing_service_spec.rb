require "rails_helper"

describe PairingService do
  describe "#rating_for_wine" do
    before do
      @wine = Wine.create!(name: "SomeWine", category: :rose)

      @earthy = Flavor.create!(name: "Earthy")
      @salty = Flavor.create!(name: "Salty")
      @sweet = Flavor.create!(name: "Sweet")

      WineFlavor.create!(wine: @wine, flavor: @earthy)
      WineFlavor.create!(wine: @wine, flavor: @salty)
      WineFlavor.create!(wine: @wine, flavor: @sweet)

      @flavors_passed_in = Flavor.where(id: [@earthy, @salty])
    end

    it "returns a WineRating with a point for each matching Flavor" do
      wine_rating = subject.rating_for_wine(wine: @wine, flavors: @flavors_passed_in)

      expect(wine_rating.wine).to eq(@wine)
      expect(wine_rating.points).to eq(2)
    end

    context "when region is passed in" do
      before do
        @region = Region.create!(name: "France")
      end

      it "doubles the score if the Region matches the wine" do
        WineRegion.create!(wine: @wine, region: @region)

        wine_rating = subject.rating_for_wine(wine: @wine, flavors: @flavors_passed_in, region: @region)

        expect(wine_rating.wine).to eq(@wine)
        expect(wine_rating.points).to eq(4)
      end

      it "does not affect points if region doesn't match" do
        wine_rating = subject.rating_for_wine(wine: @wine, flavors: @flavors_passed_in, region: @region)

        expect(wine_rating.wine).to eq(@wine)
        expect(wine_rating.points).to eq(2)
      end
    end

    context "when protein is passed in" do
      before do
        @meat = Food.create!(name: "Beef", category: :meat)
        @fish = Food.create!(name: "Tuna", category: :fish)
      end

      it "cuts the score in half if the wine is white and a protein is meat" do
        @wine.update_attributes!(category: "white")

        wine_rating = subject.rating_for_wine(wine: @wine, flavors: @flavors_passed_in, protein: @meat)

        expect(wine_rating.wine).to eq(@wine)
        expect(wine_rating.points).to eq(1)
      end

      it "cuts the score in half if the wine is red and the protein is fish" do
        @wine.update_attributes!(category: "red")

        wine_rating = subject.rating_for_wine(wine: @wine, flavors: @flavors_passed_in, protein: @fish)

        expect(wine_rating.wine).to eq(@wine)
        expect(wine_rating.points).to eq(1)
      end

      it "does not affect score otherwise" do
        wine_rating = subject.rating_for_wine(wine: @wine, flavors: @flavors_passed_in, protein: @meat)

        expect(wine_rating.wine).to eq(@wine)
        expect(wine_rating.points).to eq(2)
      end
    end
  end
end