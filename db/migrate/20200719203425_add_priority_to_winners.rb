class AddPriorityToWinners < ActiveRecord::Migration[5.2]
  def change
    add_column :winners, :priority_id, :integer
  end
end
