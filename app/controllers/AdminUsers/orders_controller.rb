module AdminUsers
  class OrdersController < BaseController
    def index
      render :index, locals: { orders: Order.where(employee: employee).order(:status), employee: employee }
    end

    def update
      if order.status_delivered?
        redirect_back fallback_location: admin_users_employees_path,
                      notice: 'The order has already been delivered.'
      elsif order.update(status: :delivered)
        EmployeeMailer.delivery_confirmation_email(order).deliver_now
        redirect_back fallback_location: admin_users_employees_path,
                      notice: 'The order has been delivered successfully!'
      else
        redirect_back fallback_location: admin_users_employees_path,
                      notice: 'The order has not been delivered :('
      end
    end

    private

    def employee
      @employee ||= Employee.find(params[:employee])
    end

    def order
      @order ||= Order.find(params[:id])
    end
  end
end
