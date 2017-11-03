Types::QueryType = GraphQL::ObjectType.define do
  name "Query"

  field :wines do
    type types[Types::WineType]
    argument :name, types.String
    argument :category, types.String
    description "Get wines"

    resolve ->(obj, args, context) {
      Wine.filtered_with_params(args.to_h.symbolize_keys)
    }
  end

  field :foods do
    type types[Types::FoodType]
    argument :name, types.String
    argument :category, types.String
    description "Get foods"

    resolve ->(obj, args, context) {
      Food.filtered_with_params(args.to_h.symbolize_keys)
    }
  end

  field :wine_ratings do
    type types[Types::WineRatingType]
    argument :food_ids, !types[types.Int]
    argument :region_id, types.Int
    description "Get wines ranked by selected foods"

    resolve ->(obj, args, context) {
      pairing_service = PairingService.new
      flavors = Flavor.joins(food_flavors: :food).where(foods: {id: args.food_ids})
      region = Region.find_by(id: args.region_id)
      protein = ProteinService.new.get_protein(Food.where(id: args.food_ids))

      Wine.all
        .map { |wine| pairing_service.rating_for_wine(wine: wine, flavors: flavors, region: region, protein: protein) }
        .sort_by(&:points)
        .reverse
    }
  end
end
