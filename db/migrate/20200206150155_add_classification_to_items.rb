class AddClassificationToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :classification, :string, default: 'Unlimited'
  end
end
