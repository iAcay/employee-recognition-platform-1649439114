class OrderPostForm
  include ActiveModel::Model

  attr_accessor :reward_id, :employee_id, :street, :postcode, :city

  def save
    ActiveRecord::Base.transaction do
      reward = Reward.find_by(id: reward_id)
      current_employee = Employee.find_by(id: employee_id)
      order = Order.new(employee_id: employee_id, reward_id: reward_id)

      if current_employee.address.nil?
        address = current_employee.build_address(street: street, postcode: postcode, city: city)
        address.save!
      else
        address = current_employee.address
        address.update!(street: street, postcode: postcode, city: city)
      end

      order.reward_snapshot = reward
      order.address_snapshot = address
      order.save!
      current_employee.decrement(:earned_points, reward.price).save!
    end
    true
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordInvalid => e
    errors.add(:base, e.message)
    false
  end
end
