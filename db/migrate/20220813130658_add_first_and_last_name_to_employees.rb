class AddFirstAndLastNameToEmployees < ActiveRecord::Migration[6.1]
  def change
    add_column :employees, :first_name, :string, default: "No", null: false
    add_column :employees, :last_name, :string, default: "Name", null: false
  end
end
