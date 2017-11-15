Types::UserType = GraphQL::ObjectType.define do
  name "User"

  field :id, types.Int, "ID for user"
  field :email, types.String, "Email of the user"
end