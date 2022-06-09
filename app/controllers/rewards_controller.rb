class RewardsController < ApplicationController
  before_action :authenticate_employee!

  def index
    render :index, locals: { rewards: Reward.order(title: :asc) }
  end

  def show
    render :show, locals: { reward: reward }
  end

  private

  def reward
    @reward ||= Reward.find(params[:id])
  end
end
