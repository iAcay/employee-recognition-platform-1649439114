# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_back fallback_location: root_path,
                  alert: "It's too late. You can working on kudo only for 5 minutes after it was sent."
  end

  def pundit_user
    current_employee
  end
end
