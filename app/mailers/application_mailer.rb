# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:sendgrid, :sender_email)
  layout 'mailer'
end
