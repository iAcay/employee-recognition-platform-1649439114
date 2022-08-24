class Order < ApplicationRecord
  serialize :reward_snapshot
  serialize :address_snapshot

  belongs_to :employee
  belongs_to :reward

  enum status: { not_delivered: 0, delivered: 1 }, _prefix: true
  scope :filter_by_status, ->(status) { where(status: status) }
end
