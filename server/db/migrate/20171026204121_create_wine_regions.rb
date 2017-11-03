class CreateWineRegions < ActiveRecord::Migration[5.1]
  def change
    create_table :wine_regions do |t|
      t.belongs_to :wine
      t.belongs_to :region

      t.timestamps
    end
  end
end
