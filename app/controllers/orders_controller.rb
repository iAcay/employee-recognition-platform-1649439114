class OrdersController < ApplicationController
  before_action :authenticate_employee!

  def new
    @reward = Reward.find(params[:reward])
    if current_employee.earned_points < @reward.price
      redirect_to rewards_path, notice: "This reward is too expensive for you.
                                        You need #{@reward.price - current_employee.earned_points} points more."
    else
      render :new, locals: { order: Order.new, order_form: which_order_form.new }
    end
  end

  def create
    @reward = Reward.find(params[:order][:reward_id])
    if current_employee.earned_points < @reward.price
      redirect_to rewards_path, notice: "This reward is too expensive for you.
                                          You need #{@reward.price - current_employee.earned_points} points more."
    else
      order_form = which_order_form.new(order_form_params)
      if order_form.save
        redirect_to rewards_path, notice: "Reward: #{@reward.title} was successfully bought. Congratulations!"
      else
        render :new, locals: { order: Order.new, order_form: order_form }
        flash[:alert] = 'Unfortunately something went wrong :('
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

  def order_form_params
    order_params.merge(address_params)
  end

  def which_order_form
    return OrderPostForm if @reward.delivery_method == 'post_delivery'

    OrderOnlineForm
  end
end
