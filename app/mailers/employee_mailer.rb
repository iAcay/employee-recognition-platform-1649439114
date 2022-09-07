class EmployeeMailer < ApplicationMailer
  def delivery_confirmation_email(order)
    @order = order
    @employee = order.employee
    @reward = order.reward_snapshot
    mail(to: @employee.email, subject: 'Reward has been delivered!')
  end
end
