module AdminUsers
  class KudosController < BaseController
    def index
      render :index, locals: { kudos: Kudo.includes(:receiver, :giver, :company_value).all.order(created_at: :desc) }
    end

    def destroy
      return unless kudo.destroy

      redirect_to admin_users_kudos_path, notice: 'Kudo was successfully destroyed.'
      kudo.giver.increment(:number_of_available_kudos).save
      kudo.receiver.decrement(:earned_points).save
    end

    private

    def kudo
      @kudo ||= Kudo.find(params[:id])
    end
  end
end
