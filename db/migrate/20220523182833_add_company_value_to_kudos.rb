class AddCompanyValueToKudos < ActiveRecord::Migration[6.1]
  def change
    add_reference :kudos, :company_value, null: false, foreign_key: { to_table: :company_values }
  end
end
