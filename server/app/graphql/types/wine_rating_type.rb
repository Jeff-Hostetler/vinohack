Types::WineRatingType = GraphQL::ObjectType.define do
  name "WineRating"

  field :points, types.Int, "Points/rating for the wine"
  field :wine, Types::WineType, "The wine"
end