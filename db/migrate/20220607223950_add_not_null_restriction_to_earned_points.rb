class AddNotNullRestrictionToEarnedPoints < ActiveRecord::Migration[6.1]
  def change
    change_table :employees do |t|
      t.change :earned_points, :bigint, default: 0, null: false
    end
  end
end
