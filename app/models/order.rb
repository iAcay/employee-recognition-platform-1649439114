class Order < ApplicationRecord
  serialize :reward_snapshot

  belongs_to :employee
  belongs_to :reward
end
