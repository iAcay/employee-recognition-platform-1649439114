class CreateOrderService
  attr_reader :errors

  def initialize(params)
    @reward = Reward.find_by(id: params[:reward_id])
    @employee = Employee.find_by(id: params[:employee_id])
    @order = Order.new(employee_id: @employee.id, reward_id: @reward.id)
    @street = params[:street]
    @postcode = params[:postcode]
    @city = params[:city]
    @errors = []
  end

  def call
    return false unless reward_for_sale?

    ActiveRecord::Base.transaction do
      create_or_update_address if @reward.delivery_method_post_delivery?
      assign_online_code if @reward.delivery_method_online?
      @order.reward_snapshot = @reward
      @order.save!
      @employee.decrement(:earned_points, @reward.price).save!
      send_email_to_employee if @reward.delivery_method_online?
    end
    true
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordInvalid => e
    @errors << e.message
    false
  end

  private

  def reward_for_sale?
    return true if @reward.available_for_purchase?

    @errors << 'Reward is not available now.'
    false
  end

  def create_or_update_address
    if @employee.address.nil?
      address = @employee.build_address(street: @street, postcode: @postcode, city: @city)
      address.save!
    else
      address = @employee.address
      address.update!(street: @street, postcode: @postcode, city: @city)
    end
    @order.address_snapshot = address
  end

  def assign_online_code
    online_code = @reward.online_codes.where(status: :not_used).sample
    @order.online_code = online_code
    online_code.update!(status: :used)
  end

  def send_email_to_employee
    @order.status_delivered!
    EmployeeMailer.delivery_confirmation_email(@order).deliver_now
  end
end
