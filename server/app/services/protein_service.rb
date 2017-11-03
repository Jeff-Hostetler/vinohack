class ProteinService
  # @param [ActiveRecord::Relation<Foods>] foods
  #
  # @return [Food] if a matching food is found otherwise nil
  def get_protein(foods)
    foods.find_by(category: "meat") || foods.find_by(category: "fish")
  end
end