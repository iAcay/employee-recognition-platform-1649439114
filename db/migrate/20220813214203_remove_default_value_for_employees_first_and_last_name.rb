class RemoveDefaultValueForEmployeesFirstAndLastName < ActiveRecord::Migration[6.1]
  def change
    change_column_default(:employees, :first_name, from: 'No', to: nil)
    change_column_default(:employees, :last_name, from: 'Name', to: nil)
  end
end
