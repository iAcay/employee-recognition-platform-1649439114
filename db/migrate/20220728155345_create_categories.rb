class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :title, null: false

      t.timestamps
    end

    add_reference :rewards, :category, foreign_key: { to_table: :categories }
  end
end
