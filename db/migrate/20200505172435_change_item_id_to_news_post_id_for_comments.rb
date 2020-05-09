class ChangeItemIdToNewsPostIdForComments < ActiveRecord::Migration[5.2]
  def change
    rename_column :comments, :item_id, :news_post_id
  end
end
