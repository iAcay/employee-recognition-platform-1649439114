class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.string :street, null: false
      t.string :postcode, null: false
      t.string :city, null: false

      t.timestamps
    end
    add_column :orders, :address_snapshot, :text
    add_reference :employees, :address, foreign_key: { to_table: :addresses }
  end
end
