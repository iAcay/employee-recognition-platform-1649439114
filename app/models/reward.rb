class Reward < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :employees, through: :orders
  belongs_to :category, optional: true

  validates :title, :description, :price, :delivery_method, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 1 }

  enum delivery_method: { online: 0, post_delivery: 1 }, _prefix: true
  scope :by_category, ->(category) { where(category: category) if Category.exists?(id: category) }

  has_one_attached :photo
  validates :photo, content_type: %i[jpg png]

  def display_category
    category.present? ? category.title : 'without category'
  end
end
