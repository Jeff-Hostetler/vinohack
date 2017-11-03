class WineRating
  def initialize(wine:, points:)
    @wine = wine
    @points = points
  end

  attr_reader :wine, :points
end