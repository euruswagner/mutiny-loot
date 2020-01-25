class CreatePriorities < ActiveRecord::Migration[5.2]
  def change
    create_table :priorities do |t|
      t.integer :ranking
      t.integer :raider_id
      t.integer :item_id
      t.timestamps
    end
  end
end
