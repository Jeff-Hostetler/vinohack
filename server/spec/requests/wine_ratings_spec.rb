require "rails_helper"

describe "WineRatings API" do
  before do
    @steak = Food.create!(name: "steak", category: "meat")
    @carrot = Food.create!(name: "mushroom", category: "veg")

    @malbec = Wine.create!(name: "malbec", category: "red")
    @cab = Wine.create!(name: "cab", category: "red")
    @riesling = Wine.create!(name: "reisling", category: "white")

    earthy = Flavor.create!(name: "earthy")
    fruity = Flavor.create!(name: "fruity")

    WineFlavor.create!(wine: @malbec, flavor: earthy)
    WineFlavor.create!(wine: @cab, flavor: earthy)
    WineFlavor.create!(wine: @riesling, flavor: earthy)
    WineFlavor.create!(wine: @cab, flavor: fruity)
    WineFlavor.create!(wine: @riesling, flavor: fruity)

    FoodFlavor.create!(food: @steak, flavor: earthy)
    FoodFlavor.create!(food: @carrot, flavor: fruity)
  end

  it "gets a sorted list of WineRatings" do
    query = <<-GQL
        {
          wine_ratings(food_ids: [#{@steak.id}, #{@carrot.id}]) {
            wine {
              id
              name
              category
            }
            points
          }
        }
    GQL

    post("/query", params: {query: query})

    expect(response.status).to eq(200)
    wine_ratings_response = JSON.parse(response.body, symbolize_names: true)[:data][:wine_ratings]

    cab_response = wine_ratings_response[0]
    expect(cab_response[:wine][:id]).to eq(@cab.id)
    expect(cab_response[:wine][:name]).to eq("cab")
    expect(cab_response[:wine][:category]).to eq("red")
    expect(cab_response[:points]).to eq(2)

    malbec_response = wine_ratings_response.find {|rating| rating[:wine][:id] == @malbec.id}
    expect(malbec_response[:points]).to eq(1)

    riesling_response = wine_ratings_response.find {|rating| rating[:wine][:id] == @riesling.id}
    expect(riesling_response[:points]).to eq(1)
  end

  it "optionally takes a region_id into account" do
    california = Region.create!(name: "Cali")
    WineRegion.create!(wine: @cab, region: california)

    query = <<-GQL
        {
          wine_ratings(food_ids: [#{@steak.id}, #{@carrot.id}], region_id: #{california.id}) {
            wine {
              id
            }
            points
          }
        }
    GQL

    post("/query", params: {query: query})

    expect(response.status).to eq(200)
    wine_ratings_response = JSON.parse(response.body, symbolize_names: true)[:data][:wine_ratings]

    cab_response = wine_ratings_response[0]
    expect(cab_response[:wine][:id]).to eq(@cab.id)
    expect(cab_response[:points]).to eq(4)
  end

  it "returns an error when food_ids not present" do
    query = <<-GQL
        {
          wine_ratings {
            wine {
              id
            }
            points
          }
        }
    GQL

    post("/query", params: {query: query})

    expect(response.status).to eq(422)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response_body[:errors][0][:message]).to eq("Field 'wine_ratings' is missing required arguments: food_ids")
  end
end