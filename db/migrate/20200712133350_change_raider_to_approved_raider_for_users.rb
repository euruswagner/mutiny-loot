class ChangeRaiderToApprovedRaiderForUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :raider, :approved_raider
  end
end
