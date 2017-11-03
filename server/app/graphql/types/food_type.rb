Types::FoodType = GraphQL::ObjectType.define do
  name "Food"
  implements(Types::BasicInfoInterface, inherit: true)
end