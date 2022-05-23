class CompanyValue < ApplicationRecord
  has_many :kudos, foreign_key: 'company_value', inverse_of: :company_value, dependent: :destroy

  validates :title, presence: true, uniqueness: { case_sensitive: false }
end
