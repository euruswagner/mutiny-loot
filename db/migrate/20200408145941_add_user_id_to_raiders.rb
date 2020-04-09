class AddUserIdToRaiders < ActiveRecord::Migration[5.2]
  def change
    add_column :raiders, :user_id, :integer
  end
end
