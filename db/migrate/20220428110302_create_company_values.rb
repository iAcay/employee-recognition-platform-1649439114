class CreateCompanyValues < ActiveRecord::Migration[6.1]
  def change
    create_table :company_values do |t|
      t.string :title, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
