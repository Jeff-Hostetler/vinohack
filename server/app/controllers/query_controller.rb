class QueryController < ApplicationController

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {}

    result = PairingApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    status = get_result_status(result, context)
    render json: result, status: status
  end

  private

  # Handle form data, JSON body, or a blank value
  # from graphql generator
  def ensure_hash(ambiguous_param)
    case ambiguous_param
      when String
        if ambiguous_param.present?
          ensure_hash(JSON.parse(ambiguous_param))
        else
          {}
        end
      when Hash, ActionController::Parameters
        ambiguous_param
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def get_result_status(result, context)
    result.query.static_errors.any? || context[:return_error_response] ? :unprocessable_entity : :ok
  end
end
