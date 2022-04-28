module Accessible
  extend ActiveSupport::Concern

  protected

  def check_admin
    return unless current_admin_user

    flash[:notice] = 'You cannot be logged in as an admin.'
    redirect_back(fallback_location: dashboard_admin_users_pages_path)
  end

  def check_employee
    return unless current_employee

    flash[:notice] = 'You cannot be logged in as an employee.'
    redirect_back(fallback_location: root_path)
  end
end
