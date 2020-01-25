class ChangeClassToWhichClassInRaiders < ActiveRecord::Migration[5.2]
  def change
    rename_column :raiders, :class, :which_class
  end
end
