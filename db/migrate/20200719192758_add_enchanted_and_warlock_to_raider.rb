class AddEnchantedAndWarlockToRaider < ActiveRecord::Migration[5.2]
  def change
    add_column :raiders, :enchanted, :boolean, null: false, default: false
    add_column :raiders, :warlock, :boolean, null: false, default: false
  end
end
