module AdminUsers
  class EmployeesController < BaseController
    before_action :set_employee, only: %i[edit update destroy]

    # GET
    def index
      @employees = Employee.all
    end

    def edit; end

    def update
      if employee_params[:password].blank?
        return render :edit unless @employee.update_without_password(employee_params.except(:password))

        redirect_to admin_users_employees_path, notice: 'Employee was successfully updated.'
      elsif @employee.update(employee_params)
        redirect_to admin_users_employees_path, notice: 'Employee was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE
    def destroy
      @employee.destroy
      redirect_to admin_users_employees_path, notice: 'Employee was successfully destroyed.'
    end

    private

    def set_employee
      @employee = Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:email, :password, :number_of_available_kudos)
    end
  end
end
