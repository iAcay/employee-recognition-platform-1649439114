# frozen_string_literal: true

module Employees
  class SessionsController < Devise::SessionsController
    include Accessible
    before_action :check_admin
  end
end
