class RewardsController < ApplicationController
  before_action :authenticate_employee!

  def index
    render :index, locals: { rewards: Reward.order(title: :asc) }
  end

  def show
    render :show, locals: { reward: reward }
  end

  def buy_reward
    if current_employee.earned_points >= reward.price
      current_employee.rewards << reward
      current_employee.decrement(:earned_points, reward.price).save
      redirect_to rewards_path, notice: "Reward: #{reward.title} was successfully bought. Congratulations!"
    else
      redirect_to rewards_path,
                  notice: "This reward is too expensive for you.
                          You need #{reward.price - current_employee.earned_points} points more."
    end
  end

  private

  def reward
    @reward ||= Reward.find(params[:id])
  end
end
