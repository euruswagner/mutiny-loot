class AddPhaseAndLockedToPriorities < ActiveRecord::Migration[5.2]
  def change
    add_column :priorities, :phase, :integer, null: 3, default: 3
    add_column :priorities, :locked, :boolean, null: true, default: true
  end
end
