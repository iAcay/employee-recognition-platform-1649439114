require 'rails_helper'

RSpec.describe EmployeeMailer, type: :mailer do
  describe 'delivery confirmation email sending' do
    context 'when online delivery' do
      let(:online_code) { create(:online_code) }
      let(:order) { create(:order, online_code: online_code) }
      let(:email) { described_class.online_delivery_confirmation_email(order) }

      it 'renders the headers' do
        expect(email.subject).to eq 'Reward has been delivered!'
        expect(email.to).to eq [order.employee.email]
        expect(email.from).to eq [Rails.application.credentials.dig(:sendgrid, :sender_email)]
      end

      it 'renders the body' do
        expect(email.text_part.body).to have_content order.reward.title
        expect(email.text_part.body).to have_content order.online_code.code
        expect(email.html_part.body).to have_content order.reward.title
        expect(email.html_part.body).to have_content order.online_code.code
      end
    end

    context 'when post delivery' do
      let(:reward) { create(:reward, delivery_method: 'post') }
      let(:order) { create(:order, reward: reward) }
      let(:email) { described_class.post_delivery_confirmation_email(order) }

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

    context 'when pick up delivery' do
      let(:reward) { create(:reward, delivery_method: 'pick_up') }
      let(:order) { create(:order, reward: reward) }

      it 'renders email headers with instructions' do
        email = described_class.pick_up_delivery_instructions_email(order)

        expect(email.subject).to eq 'Pick-up delivery instructions'
        expect(email.to).to eq [order.employee.email]
        expect(email.from).to eq [Rails.application.credentials.dig(:sendgrid, :sender_email)]
      end

      it 'renders email body with instructions' do
        email = described_class.pick_up_delivery_instructions_email(order)

        expect(email.text_part.body).to have_content order.reward.title
        expect(email.html_part.body).to have_content order.reward.title
      end

      it 'renders email headers with confirmation' do
        email = described_class.pick_up_delivery_confirmation_email(order)

        expect(email.subject).to eq 'Reward has been received!'
        expect(email.to).to eq [order.employee.email]
        expect(email.from).to eq [Rails.application.credentials.dig(:sendgrid, :sender_email)]
      end

      it 'renders email body with confirmation' do
        email = described_class.pick_up_delivery_confirmation_email(order)

        expect(email.text_part.body).to have_content order.reward.title
        expect(email.html_part.body).to have_content order.reward.title
      end
    end
  end
end
