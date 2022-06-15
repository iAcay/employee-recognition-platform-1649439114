module AdminUsers
  class OrdersController < BaseController
    def index
      render :index, locals: { orders: Order.where(employee: employee), employee: employee }
    end

    private

    def employee
      @employee ||= Employee.find(params[:employee])
    end
  end
end
