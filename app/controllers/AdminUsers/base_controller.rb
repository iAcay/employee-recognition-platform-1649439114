module AdminUsers
  class BaseController < ApplicationController
    before_action :authenticate_admin_user!

    layout 'admin_user'
  end
end
