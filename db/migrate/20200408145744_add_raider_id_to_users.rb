class AddRaiderIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :raider_id, :integer
  end
end
