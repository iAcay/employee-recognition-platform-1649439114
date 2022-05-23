class Kudo < ApplicationRecord
  belongs_to :giver, class_name: 'Employee', inverse_of: :given_kudos
  belongs_to :receiver, class_name: 'Employee', inverse_of: :received_kudos
  belongs_to :company_value, inverse_of: :kudos

  validates :title, :content, presence: true
end
