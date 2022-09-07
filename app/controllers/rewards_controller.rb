class RewardsController < ApplicationController
  before_action :authenticate_employee!

  def index
    render :index, locals: { categories: Category.order(title: :asc),
                             rewards: Reward.order(created_at: :asc)
                                            .includes([:category])
                                            .with_attached_photo
                                            .by_category(params[:category])
                                            .paginate(page: params[:page], per_page: 3) }
  end

  def show
    if reward.available_for_purchase?
      render :show, locals: { reward: reward }
    else
      redirect_back fallback_location: rewards_path, alert: 'Reward is not available now.'
    end
  end

  private

  def reward
    @reward ||= Reward.find(params[:id])
  end
end
