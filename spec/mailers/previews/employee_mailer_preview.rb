# frozen_string_literal: true

class EmployeeMailerPreview < ActionMailer::Preview
  def online_delivery_confirmation_email
    online_code = FactoryBot.build(:online_code)
    order = FactoryBot.build(:order, online_code: online_code)

    EmployeeMailer.online_delivery_confirmation_email(order)
  end

  def post_delivery_confirmation_email
    reward = FactoryBot.build(:reward, delivery_method: 'post')
    order = FactoryBot.build(:order, reward: reward)

    EmployeeMailer.post_delivery_confirmation_email(order)
  end

  def pick_up_delivery_instructions_email
    reward = FactoryBot.build(:reward, delivery_method: 'pick_up')
    order = FactoryBot.build(:order, reward: reward)

    EmployeeMailer.pick_up_delivery_instructions_email(order)
  end

  def pick_up_delivery_confirmation_email
    reward = FactoryBot.build(:reward, delivery_method: 'pick_up')
    order = FactoryBot.build(:order, reward: reward)

    EmployeeMailer.pick_up_delivery_confirmation_email(order)
  end
end
