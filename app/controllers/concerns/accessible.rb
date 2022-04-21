module Accessible
  extend ActiveSupport::Concern

  protected

  def check_admin
    return unless current_admin_user

    flash[:notice] = 'You cannot be looged in as an admin.'
    redirect_back(fallback_location: root_path)
  end

  def check_employee
    return unless current_employee

    flash[:notice] = 'You cannot be looged in as a employee.'
    redirect_back(fallback_location: root_path)
  end
end
