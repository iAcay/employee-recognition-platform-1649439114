FactoryBot.define do
  factory :order do
    employee
    reward
    reward_snapshot { reward }
  end
end
