class EmployeeMailer < ApplicationMailer
  def online_delivery_confirmation_email(order)
    @order = order
    @employee = order.employee
    @reward = order.reward_snapshot
    mail(to: @employee.email, subject: 'Reward has been delivered!')
  end

  def post_delivery_confirmation_email(order)
    @employee = order.employee
    @reward = order.reward_snapshot
    mail(to: @employee.email, subject: 'Reward has been delivered!')
  end

  def pick_up_delivery_instructions_email(order)
    @employee = order.employee
    @reward = order.reward_snapshot
    mail(to: @employee.email, subject: 'Pick-up delivery instructions')
  end

  def pick_up_delivery_confirmation_email(order)
    @employee = order.employee
    @reward = order.reward_snapshot
    mail(to: @employee.email, subject: 'Reward has been received!')
  end
end
