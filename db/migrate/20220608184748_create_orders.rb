class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.bigint :employee_id
      t.bigint :reward_id
      t.timestamps
    end
  end
end
