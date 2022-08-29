class OrdersController < ApplicationController
  before_action :authenticate_employee!

  def new
    @reward = Reward.find(params[:reward])
    if current_employee.earned_points < @reward.price
      redirect_to rewards_path, notice: "This reward is too expensive for you.
                                        You need #{@reward.price - current_employee.earned_points} points more."
    else
      render :new, locals: { order: Order.new }
    end
  end

  def create
    @reward = Reward.find(params[:order][:reward_id])
    if current_employee.earned_points < @reward.price
      redirect_to rewards_path, notice: "This reward is too expensive for you.
                                          You need #{@reward.price - current_employee.earned_points} points more."
    else
      create_order = CreateOrderService.new(create_order_params)
      if create_order.call
        redirect_to rewards_path, notice: "Reward: #{@reward.title} was successfully bought. Congratulations!"
      else
        redirect_back fallback_location: rewards_path, alert: create_order.errors.join('; ')
      end
    end
  end

  private

  def order_params
    params.require(:order).permit(:employee_id, :reward_id, :reward_snapshot)
  end

  def address_params
    params.require(:address).permit(:street, :postcode, :city) if params[:address]
  end

  def create_order_params
    order_params.merge(address_params)
  end
end
