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

    def edit_number_of_available_kudos_for_all
      render :edit_number_of_available_kudos_for_all, locals: { employees: Employee.all }
    end

    def update_number_of_available_kudos_for_all
      if added_kudos_params.positive? && added_kudos_params <= 20
        begin
          ActiveRecord::Base.transaction do
            Employee.all.each do |employee|
              employee.increment(:number_of_available_kudos, added_kudos_params).save!
            end
          end
        rescue StandardError
          redirect_to dashboard_admin_users_pages_path, alert: 'Unfortunately something went wrong :('
        else
          redirect_to admin_users_employees_path,
                      notice: "Each employee received #{added_kudos_params} additional kudos for use."
        end
      else
        redirect_to dashboard_admin_users_pages_path,
                    alert: 'Given number is not valid, please enter a number between 1 to 20.'
      end
    end

    private

    def employee
      @employee ||= Employee.find(params[:id])
    end

    def employee_params
      params.require(:employee).permit(:email, :password, :number_of_available_kudos)
    end

    def added_kudos_params
      params[:number_of_added_kudos].to_i
    end
  end
end
