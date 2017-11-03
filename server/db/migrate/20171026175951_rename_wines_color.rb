class RenameWinesColor < ActiveRecord::Migration[5.1]
  def change
    rename_column :wines, :color, :category
  end
end
