class CreateRaiders < ActiveRecord::Migration[5.2]
  def change
    create_table :raiders do |t|
      t.string :name
      t.string :class
      t.string :role
      t.integer :points_earned
      t.integer :points_spent
      t.timestamps
    end
  end
end
