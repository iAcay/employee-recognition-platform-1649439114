# frozen_string_literal: true

module Employees
  class RegistrationsController < Devise::RegistrationsController
    include Accessible
    before_action :check_admin
  end
end
