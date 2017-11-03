Types::WineType = GraphQL::ObjectType.define do
  name "Wine"
  implements(Types::BasicInfoInterface, inherit: true)
end