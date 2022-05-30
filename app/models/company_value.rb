class CompanyValue < ApplicationRecord
  has_many :kudos, dependent: :restrict_with_error
  validates :title, presence: true, uniqueness: { case_sensitive: false }
end
