class AddCategoryRemoveCategoryIdForItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :category, :string
    remove_column :items, :category_id
  end
end
