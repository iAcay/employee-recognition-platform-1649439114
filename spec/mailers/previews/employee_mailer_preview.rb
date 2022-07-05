# frozen_string_literal: true

class EmployeeMailerPreview < ActionMailer::Preview
  def send_delivery_confirmation_email
    EmployeeMailer.with(order: FactoryBot.build(:order)).send_delivery_confirmation_email(FactoryBot.build(:order))
  end
end
