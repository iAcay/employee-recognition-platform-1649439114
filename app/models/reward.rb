class Reward < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :employees, through: :orders
  belongs_to :category, optional: true

  validates :title, :description, :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 1 }

  scope :by_category, ->(category) { where(category: category) if Category.exists?(id: category) }

  def category?
    category.present? ? category.title : 'without category'
  end
end
