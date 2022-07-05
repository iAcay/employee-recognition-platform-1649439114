class EmployeeMailer < ApplicationMailer
  def send_delivery_confirmation_email(order)
    @employee = order.employee
    @reward = order.reward_snapshot
    mail(to: @employee.email,
         subject: 'Reward has been delivered!')
  end
end
