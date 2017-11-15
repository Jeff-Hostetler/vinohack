require "rails_helper"

describe "Users API" do
  describe "creating a user" do
    it "can create a new user" do
      query = <<-GQL
        mutation create_user{
          create_user(input: { email: "new_user@example.com", password: "password123", password_confirmation: "password123"})
          {
            user{
              id
              email
            }
            errors
          }
        }
      GQL

      post("/query", params: { query: query })

      expect(response.status).to eq(200)

      create_user_response = JSON.parse(response.body, symbolize_names: true)[:data][:create_user]
      user_response = create_user_response[:user]
      created_user = User.first

      expect(user_response[:id]).to eq(created_user.id)
      expect(user_response[:email]).to eq("new_user@example.com")
      expect(created_user.email).to eq("new_user@example.com")

      expect(create_user_response[:errors]).to eq(nil)
    end

    it "returns errors when the user email is taken" do
      User.create!(email: "taken@example.com", password: "password")

      query = <<-GQL
        mutation create_user{
          create_user(input: { email: "taken@example.com", password: "password123", password_confirmation: "password123"})
          {
            user{
              id
              email
            }
            errors
          }
        }
      GQL

      post("/query", params: { query: query })

      expect(response.status).to eq(422)

      error_response = JSON.parse(response.body, symbolize_names: true)[:data][:create_user][:errors]

      expect(error_response).to match_array(["Email has already been taken"])
      expect(User.count).to eq 1
    end

    it "return errors when the password and confirmation do not match" do
      query = <<-GQL
        mutation create_user{
          create_user(input: { email: "new_user@example.com", password: "right", password_confirmation: "wrong"})
          {
            user{
              id
              email
            }
            errors
          }
        }
      GQL

      post("/query", params: { query: query })

      expect(response.status).to eq(422)

      error_response = JSON.parse(response.body, symbolize_names: true)[:data][:create_user][:errors]

      expect(error_response).to match_array(["Password fields do not match"])
      expect(User.count).to eq 0
    end
  end
end