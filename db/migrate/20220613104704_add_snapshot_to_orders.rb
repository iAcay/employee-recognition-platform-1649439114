class AddSnapshotToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :reward_snapshot, :text
  end
end
