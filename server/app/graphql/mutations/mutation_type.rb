MutationType = GraphQL::ObjectType.define do
  name "Mutation"

  field :create_user, field: UserMutations::Create.field
end
