module AdminUsers
  class PagesController < ApplicationController
    before_action :authenticate_admin_user!

    def dashboard; end
  end
end
