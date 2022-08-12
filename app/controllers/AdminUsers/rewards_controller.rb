require 'csv'

module AdminUsers
  class RewardsController < BaseController
    def index
      render :index, locals: { rewards: Reward.order(title: :asc).with_attached_photo.includes([:category]) }
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

    def new_import_from_csv
      render :new_import_from_csv, locals: { reward: Reward.new }
    end

    def import_from_csv
      if params[:reward][:file].nil?
        redirect_to new_import_from_csv_admin_users_rewards_path, alert: 'Please select a file'
      elsif File.extname(params[:reward][:file]) != '.csv'
        redirect_to new_import_from_csv_admin_users_rewards_path, alert: 'Only .csv files are allowed.'
      else
        begin
          RewardsImportService.import(params[:reward][:file])
        rescue ActiveRecord::RecordInvalid => e
          redirect_to new_import_from_csv_admin_users_rewards_path,
                      alert: "Errors in CSV file: <br> #{e.message}."
        else
          redirect_to admin_users_rewards_path, notice: 'Rewards were successfully imported.'
        end
      end
    end

    private

    def reward
      @reward ||= Reward.find(params[:id])
    end

    def reward_params
      params.require(:reward).permit(:title, :description, :price, :category_id, :photo)
    end
  end
end
