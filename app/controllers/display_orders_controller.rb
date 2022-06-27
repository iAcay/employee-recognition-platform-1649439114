class DisplayOrdersController < ApplicationController
  before_action :authenticate_employee!

  def index
    case params[:filter]
    when 'Delivered rewards'
      render :index, locals: { orders: Order.where(employee: current_employee, status: :delivered)
                                            .paginate(page: params[:page], per_page: 5)
                                            .order(created_at: :desc) }
    when 'Undelivered rewards'
      render :index, locals: { orders: Order.where(employee: current_employee, status: :not_delivered)
                                            .paginate(page: params[:page], per_page: 5)
                                            .order(created_at: :desc) }
    else
      render :index, locals: { orders: Order.where(employee: current_employee)
                                            .paginate(page: params[:page], per_page: 5)
                                            .order(created_at: :desc) }
    end
  end
end
