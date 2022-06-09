class OrdersController < ApplicationController
  before_action :authenticate_employee!

  def index; end

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
      @order = Order.new(order_params)
      if @order.save && current_employee.decrement(:earned_points, @reward.price).save
        redirect_to rewards_path, notice: "Reward: #{@reward.title} was successfully bought. Congratulations!"
      else
        render :new, locals: { order: @order }
      end
    end
  end

  private

  def order_params
    params.require(:order).permit(:employee_id, :reward_id)
  end
end
