class Address < ApplicationRecord
  belongs_to :employee, optional: true

  validates :street, :postcode, :city, presence: true
end
