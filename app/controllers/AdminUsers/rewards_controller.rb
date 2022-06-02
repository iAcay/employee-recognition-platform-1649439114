module AdminUsers
  class RewardsController < BaseController
    def index
      render :index, locals: { rewards: Reward.order(title: :asc) }
    end

    def show
      render :show, locals: { reward: reward }
    end

    def new
      render :new, locals: { reward: Reward.new }
    end

    def edit
      render :edit, locals: { reward: reward }
    end

    def create
      record = Reward.new(reward_params)

      if record.save
        redirect_to admin_users_rewards_path, notice: 'Reward was successfully created.'
      else
        render :new, locals: { reward: record }
      end
    end

    def update
      if reward.update(reward_params)
        redirect_to admin_users_rewards_path, notice: 'Reward was successfully updated.'
      else
        render :edit, locals: { reward: reward }
      end
    end

    def destroy
      redirect_to admin_users_rewards_path, notice: 'Reward was successfully deleted.' if reward.destroy
    end

    private

    def reward
      @reward ||= Reward.find(params[:id])
    end

    def reward_params
      params.require(:reward).permit(:title, :description, :price)
    end
  end
end
