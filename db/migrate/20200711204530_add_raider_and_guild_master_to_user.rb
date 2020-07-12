class AddRaiderAndGuildMasterToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :raider, :boolean, null: false, default: false
    add_column :users, :guild_master, :boolean, null: false, default: false
  end
end
