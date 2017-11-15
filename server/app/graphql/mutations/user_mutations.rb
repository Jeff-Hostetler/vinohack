module UserMutations
  Create = GraphQL::Relay::Mutation.define do
    name "CreateUser"

    # Define input parameters
    input_field :email, !types.String
    input_field :password, !types.String
    input_field :password_confirmation, !types.String

    # Define return parameters
    return_field :user, Types::UserType
    return_field :errors, types[types.String]

    resolve ->(object, inputs, ctx) {
      if inputs[:password] != inputs[:password_confirmation]
        ctx[:return_error_response] = true
        return {errors: ["Password fields do not match"]}
      end
      user = User.new(email: inputs[:email], password: inputs[:password])
      if user.save
        { user: user }
      else
        ctx[:return_error_response] = true
        {errors: user.errors.full_messages}
      end
    }
  end
end