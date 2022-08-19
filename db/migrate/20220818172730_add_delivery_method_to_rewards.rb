class AddDeliveryMethodToRewards < ActiveRecord::Migration[6.1]
  def change
    add_column :rewards, :delivery_method, :integer, default: 0, null: false
  end
end
