class ChangeReferenceEmployeesToAddresses < ActiveRecord::Migration[6.1]
  def change
    remove_reference :employees, :address, foreign_key: { to_table: :addresses }
    add_reference :addresses, :employee, foreign_key: { to_table: :employees }
  end
end
