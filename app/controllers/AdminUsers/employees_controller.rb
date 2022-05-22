module AdminUsers
  class EmployeesController < BaseController
    def index
      render :index, locals: { employees: Employee.all.order(:email) }
    end

    def edit
      render :edit, locals: { employee: employee }
    end

    def update
      if employee_params[:password].blank?
        return render :edit unless employee.update_without_password(employee_params.except(:password))

        redirect_to admin_users_employees_path, notice: 'Employee was successfully updated.'
      elsif employee.update(employee_params)
        redirect_to admin_users_employees_path, notice: 'Employee was successfully updated.'
      else
        render :edit, locals: { employee: employee }
      end
    end

    def destroy
      employee.destroy
      redirect_to admin_users_employees_path, notice: 'Employee was successfully destroyed.'
    end

    private

    def employee
      @employee ||= Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:email, :password, :number_of_available_kudos)
    end
  end
end
