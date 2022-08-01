class Category < ApplicationRecord
  has_many :rewards, dependent: :restrict_with_error
  validates :title, presence: true
end
