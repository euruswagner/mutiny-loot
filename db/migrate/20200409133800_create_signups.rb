class CreateSignups < ActiveRecord::Migration[5.2]
  def change
    create_table :signups do |t|
      t.integer :raider_id
      t.integer :raid_id
      t.timestamps
    end
  end
end
