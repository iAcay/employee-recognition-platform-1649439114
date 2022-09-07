class OnlineCode < ApplicationRecord
  belongs_to :reward
  belongs_to :order, optional: true

  enum status: { not_used: 0, used: 1 }, _prefix: true

  validates :code, presence: true, uniqueness: { case_sensitive: false }
end
