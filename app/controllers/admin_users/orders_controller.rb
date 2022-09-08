require 'csv'

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
        EmployeeMailer.post_delivery_confirmation_email(order).deliver_now
        redirect_back fallback_location: admin_users_employees_path,
                      notice: 'The order has been delivered successfully!'
      else
        redirect_back fallback_location: admin_users_employees_path,
                      notice: 'The order has not been delivered :('
      end
    end

    def export_to_csv
      @orders = Order.includes([:employee]).order(created_at: :desc)

      response.headers['Content-Type'] = 'text/csv'
      response.headers['Content-Disposition'] = "attachment; filename=#{Time.zone.now.to_s(:number)}_orders.csv"
      render template: 'admin_users/orders/orders', formats: [:csv], handlers: [:erb]
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
