class AddTitleToNewsPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :news_posts, :title, :string
  end
end
