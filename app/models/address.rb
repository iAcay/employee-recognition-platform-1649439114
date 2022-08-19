class Address < ApplicationRecord
  has_one :employee, dependent: :nullify

  validates :street, :postcode, :city, presence: true
end
