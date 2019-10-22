class AlterItemsAddWinners < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :winner, :text
  end
end
