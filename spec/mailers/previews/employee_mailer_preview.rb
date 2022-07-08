# frozen_string_literal: true

class EmployeeMailerPreview < ActionMailer::Preview
  def delivery_confirmation_email
    EmployeeMailer.with(order: FactoryBot.build(:order)).delivery_confirmation_email(FactoryBot.build(:order))
  end
end
