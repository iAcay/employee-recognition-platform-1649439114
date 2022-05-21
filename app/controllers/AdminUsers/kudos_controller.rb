module AdminUsers
  class KudosController < BaseController
    before_action :admin_users_kudo, only: %i[destroy]

    # GET /kudos
    def index
      @admin_users_kudos = Kudo.includes(:receiver, :giver).all
    end

    # DELETE /kudos/1
    def destroy
      @admin_users_kudo.destroy
      redirect_to admin_users_kudos_path, notice: 'Kudo was successfully destroyed.'
      @admin_users_kudo.giver.update(number_of_available_kudos: @admin_users_kudo.giver.number_of_available_kudos + 1)
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def admin_users_kudo
      @admin_users_kudo = Kudo.find(params[:id])
    end
  end
end
