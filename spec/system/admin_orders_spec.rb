require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Admin orders listing', type: :system do
  let(:admin_user) { create(:admin_user) }

  before do
    driven_by(:rack_test)
    sign_in admin_user
  end

  context 'when listing all rewards bought by one employee' do
    let!(:order1) { create(:order) }
    let!(:order2) { create(:order) }

    it 'shows all rewards bought by employee' do
      visit admin_users_employees_path

      within('tr', text: order1.employee.email) do
        click_link 'Orders'
      end

      expect(page).to have_content "Orders made by #{order1.employee.full_name}:"
      expect(page).to have_content order1.reward.title
      expect(page).to have_content order1.reward.description
      expect(page).to have_content order1.reward.price
      expect(page).to have_content order1.created_at.strftime('%d-%m-%Y %H:%M')
      expect(order1.employee.rewards).to include order1.reward
    end

    it "doesn't show rewards bought by other employee" do
      visit admin_users_employees_path

      within('tr', text: order2.employee.email) do
        click_link 'Orders'
      end

      expect(page).to have_content "Orders made by #{order2.employee.full_name}:"
      expect(page).not_to have_content order1.reward.title
      expect(page).not_to have_content order1.reward.description
      expect(order2.employee.rewards).not_to include order1.reward
    end
  end

  context 'when delivering an order to employee' do
    it 'shows the number of not delivered orders' do
      order = create(:order)
      visit admin_users_employees_path

      within('li', text: 'Orders') do
        expect(page).to have_content order.employee.orders.where(status: :not_delivered).count
      end
    end

    it 'possible to deliver an order only once' do
      order = create(:order)
      visit admin_users_employees_path

      click_link 'Order'
      expect(order.status).to eq 'not_delivered'

      # TESTING IF ORDER CAN BE DELIVERED
      click_button 'Deliver'
      expect(page).to have_content 'The order has been delivered successfully!'
      order.reload
      expect(order.status).to eq 'delivered'

      # TESTING IF ORDER CAN BE DELIVERED MORE THAN ONE TIME
      click_button 'Deliver'
      expect(page).to have_content 'The order has already been delivered.'
    end

    it 'sends a confirmation email when an order with post delivery method has been delivered' do
      reward = create(:reward, delivery_method: 'post')
      create(:order, reward: reward)
      visit admin_users_employees_path
      click_link 'Order'
      expect { click_button 'Deliver' }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(ActionMailer::Base.deliveries.last.subject).to eq 'Reward has been delivered!'
    end

    it 'sends a confirmation email when an order with pick_up delivery method has been received' do
      reward = create(:reward, delivery_method: 'pick_up')
      create(:order, reward: reward)
      visit admin_users_employees_path
      click_link 'Order'
      expect { click_button 'Deliver' }.to change { ActionMailer::Base.deliveries.count }.by(1)
      expect(ActionMailer::Base.deliveries.last.subject).to eq 'Reward has been received!'
    end
  end
end
