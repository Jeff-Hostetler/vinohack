require "rails_helper"

describe "Wines API" do
  before do
    @riesling = Wine.create!(name: "riesling", category: "white")
    @malbec = Wine.create!(name: "malbec", category: "red")
  end
  
  it "allows a request to get all wines" do
    query = <<-GQL
        {
          wines {
            id
            name
            category
          }
        }
    GQL

    post("/query", params: {query: query})

    expect(response.status).to eq(200)

    wines_response = JSON.parse(response.body, symbolize_names: true)[:data][:wines]
    expect(wines_response.map {|wine| wine[:id]}).to match_array([@riesling.id, @malbec.id])

    riesling_response = wines_response.find {|wine| wine[:id] == @riesling.id}
    expect(riesling_response[:name]).to eq("riesling")
    expect(riesling_response[:category]).to eq("white")
  end

  it "gets requested keys" do
    query = <<-GQL
        {
          wines {
            id
          }
        }
    GQL

    post("/query", params: {query: query})

    expect(response.status).to eq(200)
    wines_response = JSON.parse(response.body, symbolize_names: true)[:data][:wines]
    expect(wines_response.first.keys).to eq([:id])
  end

  it "can search by name" do
    query = <<-GQL
        {
          wines(name: "ies") {
            id
          }
        }
    GQL

    post("/query", params: {query: query})

    expect(response.status).to eq(200)
    wines_response = JSON.parse(response.body, symbolize_names: true)[:data][:wines]

    expect(wines_response.map {|wine| wine[:id]}).to match_array([@riesling.id])
  end

  it "can search by category" do
    query = <<-GQL
        {
          wines(category: "red") {
            id
          }
        }
    GQL

    post("/query", params: {query: query})

    expect(response.status).to eq(200)
    wines_response = JSON.parse(response.body, symbolize_names: true)[:data][:wines]

    expect(wines_response.map {|wine| wine[:id]}).to match_array([@malbec.id])
  end

  it "returns errors when request is bad" do
    query = <<-GQL
        {
          wines {
            id
            fake
          }
        }
    GQL

    post("/query", params: {query: query})

    expect(response.status).to eq(422)
    response_body = JSON.parse(response.body, symbolize_names: true)
    expect(response_body[:errors][0][:message]).to eq("Field 'fake' doesn't exist on type 'Wine'")
  end
end