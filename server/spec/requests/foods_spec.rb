require "rails_helper"

describe "Foods API" do
  before do
    @mushroom = Food.create!(name: "Mushroom", category: "veg")
    @new_york_strip = Food.create!(name: "New York Strip", category: "meat")
  end
  
  it "allows a request to get all foods" do
    query = <<-GQL
        {
          foods {
            id
            name
            category
          }
        }
    GQL

    post("/query", params: {query: query})

    expect(response.status).to eq(200)

    foods_response = JSON.parse(response.body, symbolize_names: true)[:data][:foods]
    expect(foods_response.map {|wine| wine[:id]}).to match_array([@mushroom.id, @new_york_strip.id])

    mushroom_response = foods_response.find {|wine| wine[:id] == @mushroom.id}
    expect(mushroom_response[:name]).to eq("Mushroom")
    expect(mushroom_response[:category]).to eq("veg")
  end

  it "can search by name" do
    query = <<-GQL
        {
          foods(name: "rip") {
            id
          }
        }
    GQL

    post("/query", params: {query: query})

    expect(response.status).to eq(200)
    foods_response = JSON.parse(response.body, symbolize_names: true)[:data][:foods]

    expect(foods_response.map {|wine| wine[:id]}).to match_array([@new_york_strip.id])
  end

  it "can search by category" do
    query = <<-GQL
        {
          foods(category: "meat") {
            id
          }
        }
    GQL

    post("/query", params: {query: query})

    expect(response.status).to eq(200)
    foods_response = JSON.parse(response.body, symbolize_names: true)[:data][:foods]

    expect(foods_response.map {|wine| wine[:id]}).to match_array([@new_york_strip.id])
  end

  it "returns errors when request is bad" do
    query = <<-GQL
        {
          foods {
            id
            fake
          }
        }
    GQL

    post("/query", params: {query: query})

    expect(response.status).to eq(422)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response_body[:errors][0][:message]).to eq("Field 'fake' doesn't exist on type 'Food'")
  end
end