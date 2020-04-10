class AddNotesToSignups < ActiveRecord::Migration[5.2]
  def change
    add_column :signups, :notes, :string, null: '', default: ''
  end
end
