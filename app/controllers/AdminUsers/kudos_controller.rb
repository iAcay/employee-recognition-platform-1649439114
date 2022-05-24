module AdminUsers
  class KudosController < BaseController
    def index
      render :index, locals: { kudos: Kudo.includes(:receiver, :giver, :company_value).all.order('created_at DESC') }
    end

    def destroy
      kudo.destroy
      redirect_to admin_users_kudos_path, notice: 'Kudo was successfully destroyed.'
      kudo.giver.update(number_of_available_kudos: kudo.giver.number_of_available_kudos + 1)
    end

    private

    def kudo
      @kudo ||= Kudo.find(params[:id])
    end
  end
end
