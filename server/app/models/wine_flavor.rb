class WineFlavor < ActiveRecord::Base
  belongs_to :wine
  belongs_to :flavor
end