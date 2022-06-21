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

      expect(page).to have_content "Orders made by #{order1.employee.email}:"
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

      expect(page).to have_content "Orders made by #{order2.employee.email}:"
      expect(page).not_to have_content order1.reward.title
      expect(page).not_to have_content order1.reward.description
      expect(order2.employee.rewards).not_to include order1.reward
    end
  end

  context 'when delivering an order to employee' do
    let!(:order) { create(:order) }

    it 'shows the number of not delivered orders' do
      visit admin_users_employees_path

      within('li', text: 'Orders') do
        expect(page).to have_content order.employee.orders.where(status: :not_delivered).count
      end
    end

    it 'possible to deliver an order only once' do
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
  end
end
