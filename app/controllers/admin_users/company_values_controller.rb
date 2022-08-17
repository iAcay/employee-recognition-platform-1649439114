module AdminUsers
  class CompanyValuesController < BaseController
    def index
      render :index, locals: { company_values: CompanyValue.all.order(title: :asc) }
    end

    def new
      render :new, locals: { company_value: CompanyValue.new }
    end

    def edit
      render :edit, locals: { company_value: company_value }
    end

    def create
      record = CompanyValue.new(company_value_params)

      if record.save
        redirect_to admin_users_company_values_path, notice: 'Company Value was successfully created.'
      else
        render :new, locals: { company_value: record }
      end
    end

    def update
      if company_value.update(company_value_params)
        redirect_to admin_users_company_values_path, notice: 'Company Value was successfully updated.'
      else
        render :edit, locals: { company_value: company_value }
      end
    end

    def destroy
      if company_value.destroy
        redirect_to admin_users_company_values_url, notice: 'Company Value was successfully destroyed.'
      else
        redirect_to admin_users_company_values_path,
                    notice: 'This company value cannot be deleted because of its relations with existing kudos.'
      end
    end

    private

    def company_value
      @company_value ||= CompanyValue.find(params[:id])
    end

    def company_value_params
      params.require(:company_value).permit(:title)
    end
  end
end
