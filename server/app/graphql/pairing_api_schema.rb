PairingApiSchema = GraphQL::Schema.define do
  query(Types::QueryType)
  mutation(MutationType)

  resolve_type ->(type, obj, ctx) {
    #this just needs to be defined for some reason, possible bug with GraphQL
  }
end
