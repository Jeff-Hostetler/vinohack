class PairingService
  # @param [Wine] wine
  # @param [ActiveRecord::Relation<Flavor>] flavors
  # @param [Region] region
  # @param [Food] protein
  #
  # @return [WineRating]
  def rating_for_wine(wine:, flavors:, region: nil, protein: nil)
    points = WineFlavor
               .where(wine: wine)
               .where("flavor_id in (?)", flavors.pluck(:id))
               .reduce(0) { |sum, _| sum + 1 }
    points = points * 2 if wine_in_region?(wine, region)
    points = points / 2 if bad_protein_pairing?(wine, protein)

    WineRating.new(wine: wine, points: points)
  end


  private

  # @param [Wine] wine
  # @param [Region] region
  #
  # @return [Boolean]
  def wine_in_region?(wine, region)
    WineRegion.find_by(region: region, wine: wine).present?
  end

  # @param [Wine] wine
  # @param [Food] protein
  #
  # @return [Boolean]
  def bad_protein_pairing?(wine, protein)
    protein.present? && (protein.meat? && wine.white? || protein.fish? && wine.red?)
  end
end