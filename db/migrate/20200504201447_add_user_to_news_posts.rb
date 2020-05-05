class AddUserToNewsPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :news_posts, :user_id, :integer
  end
end
