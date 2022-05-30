class Reward < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true
  monetize :price_cents, numericality: { greater_than_or_equal_to: 1 }
end
