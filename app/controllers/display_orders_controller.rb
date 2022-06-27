class DisplayOrdersController < ApplicationController
  before_action :authenticate_employee!

  def index
    render :index, locals: { orders: Order.where(employee: current_employee)
                                          .paginate(page: params[:page], per_page: 5)
                                          .order(created_at: :desc) }
  end
end
