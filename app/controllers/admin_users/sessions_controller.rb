# frozen_string_literal: true

module AdminUsers
  class SessionsController < Devise::SessionsController
    include Accessible
    before_action :check_employee

    layout 'admin_user'

    def after_sign_in_path_for(_resource)
      dashboard_admin_users_pages_path
    end
  end
end
