class CreateWinners < ActiveRecord::Migration[5.2]
  def change
    create_table :winners do |t|
      t.integer :points_spent
      t.integer :raider_id
      t.integer :item_id
      t.timestamps
    end
  end
end
