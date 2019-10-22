class AlterItemsAddZone < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :zone, :string
  end
end
