Types::BasicInfoInterface = GraphQL::InterfaceType.define do
  name "BasicInfo"
  description "ID, name, categroy"

  field :id, types.Int, "The unique ID of this object"
  field :name, types.String, "Name of the object"
  field :category, types.String, "Type of object. (ex. 'protein' or 'veg')" #todo check out enum type for graphql
end