class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.string :link
      t.string :priority
      t.integer :category_id
      t.timestamps
    end

    add_index :items, :category_id
  end
end
