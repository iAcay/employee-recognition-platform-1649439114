# frozen_string_literal: true

class EmployeeMailerPreview < ActionMailer::Preview
  def online_delivery_confirmation_email
    online_code = FactoryBot.build(:online_code)
    order = FactoryBot.build(:order, online_code: online_code)

    EmployeeMailer.online_delivery_confirmation_email(order)
  end

  def post_delivery_confirmation_email
    order = FactoryBot.build(:order)

    EmployeeMailer.post_delivery_confirmation_email(order)
  end
end
