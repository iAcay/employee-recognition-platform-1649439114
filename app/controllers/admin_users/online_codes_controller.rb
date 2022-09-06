module AdminUsers
  class OnlineCodesController < BaseController
    def index
      render :index, locals: { online_codes: OnlineCode.includes(:reward).order(code: :asc) }
    end

    def new
      render :new, locals: { online_code: OnlineCode.new }
    end

    def edit
      render :edit, locals: { online_code: online_code }
    end

    def create
      online_code = OnlineCode.new(online_code_params)

      if online_code.save
        redirect_to admin_users_online_codes_path, notice: 'Online code was successfully created.'
      else
        render :new, locals: { online_code: online_code }
      end
    end

    def update
      if online_code.update(online_code_params)
        redirect_to admin_users_online_codes_path, notice: 'Online code was successfully updated.'
      else
        render :edit, locals: { online_code: online_code }
      end
    end

    def destroy
      if online_code.destroy
        redirect_to admin_users_online_codes_path, notice: 'Online code was successfully destroyed.'
      else
        redirect_to admin_users_online_codes_path, notice: 'Something went wrong :('
      end
    end

    def new_import_from_csv
      render :new_import_from_csv
    end

    def import_from_csv
      online_codes = OnlineCodesImportService.new(params)

      if online_codes.import
        redirect_to admin_users_online_codes_path, notice: 'Online codes were successfully imported.'
      else
        redirect_to admin_users_online_codes_path, alert: online_codes.errors.join('; ')
      end
    end

    private

    def online_code
      @online_code ||= OnlineCode.find(params[:id])
    end

    def online_code_params
      params.require(:online_code).permit(:code, :reward_id)
    end
  end
end
