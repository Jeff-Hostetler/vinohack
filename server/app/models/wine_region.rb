class WineRegion < ActiveRecord::Base
  belongs_to :wine
  belongs_to :region
end