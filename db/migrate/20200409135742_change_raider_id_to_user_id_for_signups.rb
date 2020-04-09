class ChangeRaiderIdToUserIdForSignups < ActiveRecord::Migration[5.2]
  def change
    rename_column :signups, :raider_id, :user_id
  end
end
