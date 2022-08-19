class OrderOnlineForm
  include ActiveModel::Model

  attr_accessor :reward_id, :employee_id

  def save
    ActiveRecord::Base.transaction do
      reward = Reward.find_by(id: reward_id)
      current_employee = Employee.find_by(id: employee_id)
      order = Order.new(employee_id: employee_id, reward_id: reward_id)
      order.reward_snapshot = reward
      order.save!
      current_employee.decrement(:earned_points, reward.price).save!
    end
    true
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end
end
