module Queryable
  extend ActiveSupport::Concern

  module ClassMethods
    def filtered_with_params(params)
      scope = all
      if params[:category]
        scope = scope.where(category: params[:category])
      end

      if params[:name]
        scope = scope.where("name ILIKE ?", "%#{params[:name].to_s.downcase}%")
      end
      scope
    end
  end
end