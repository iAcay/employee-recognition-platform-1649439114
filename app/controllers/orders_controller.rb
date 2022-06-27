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
      @order = Order.new(order_params)
      @order.reward_snapshot = @reward
      begin
        ActiveRecord::Base.transaction do
          @order.save!
          current_employee.decrement(:earned_points, @reward.price).save!
        end
      rescue StandardError
        redirect_to rewards_path, notice: 'Unfortunately something went wrong :('
      else
        redirect_to rewards_path, notice: "Reward: #{@reward.title} was successfully bought. Congratulations!"
      end
    end
  end

  private

  def order_params
    params.require(:order).permit(:employee_id, :reward_id, :reward_snapshot)
  end
end
