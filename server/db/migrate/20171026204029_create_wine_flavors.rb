class CreateWineFlavors < ActiveRecord::Migration[5.1]
  def change
    create_table :wine_flavors do |t|
      t.belongs_to :wine
      t.belongs_to :flavor

      t.timestamps
    end
  end
end
