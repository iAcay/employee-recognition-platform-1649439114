require 'rails_helper'

RSpec.describe EmployeeMailer, type: :mailer do
  describe 'delivery confirmation email sending' do
    let(:order) { create(:order) }
    let(:email) { described_class.delivery_confirmation_email(order) }

    it 'renders the headers' do
      expect(email.subject).to eq 'Reward has been delivered!'
      expect(email.to).to eq [order.employee.email]
      expect(email.from).to eq [Rails.application.credentials.dig(:sendgrid, :sender_email)]
    end

    it 'renders the body' do
      expect(email.text_part.body).to have_content order.reward.title
      expect(email.html_part.body).to have_content order.reward.title
    end
  end
end
