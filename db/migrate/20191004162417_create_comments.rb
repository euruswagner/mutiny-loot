class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :message
      t.integer :user_id
      t.integer :item_id
      t.timestamps
    end

    add_index :comments, [:user_id, :item_id]
    add_index :comments, :item_id
  end
end
