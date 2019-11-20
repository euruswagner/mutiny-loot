class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.integer :rank
      t.integer :user_id
      t.integer :item_id
      t.timestamps
    end

    add_index :lists, [:user_id, :item_id]
    add_index :lists, :item_id
  end
end
