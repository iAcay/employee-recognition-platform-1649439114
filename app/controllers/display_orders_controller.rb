class DisplayOrdersController < ApplicationController
  before_action :authenticate_employee!

  def index
    if params[:filter]
      render :index, locals: { orders: Order.where(employee: current_employee)
                                            .filter_by_status(params[:filter])
                                            .paginate(page: params[:page], per_page: 5)
                                            .order(created_at: :desc) }
    else
      render :index, locals: { orders: Order.where(employee: current_employee)
                                            .paginate(page: params[:page], per_page: 5)
                                            .order(created_at: :desc) }
    end
  end
end
