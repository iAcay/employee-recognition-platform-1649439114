require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Orders', type: :system do
  let!(:admin_user) { create(:admin_user) }
  let(:price) { 1.0 }
  let(:new_price) { 153.0 }
  let!(:order) { create(:order) }

  before do
    driven_by(:rack_test)
  end

  context 'when bought a reward' do
    it 'shows rewards list' do
      sign_in order.employee

      visit root_path
      click_link 'My Rewards'

      expect(page).to have_content order.reward.title
      expect(page).to have_content order.reward.description
      expect(page).to have_content order.reward.price
      expect(page).to have_content order.created_at.strftime('%d-%m-%Y %H:%M')
      expect(order.employee.rewards).to include order.reward
    end

    it "reward price change doesn't affect the order price which have been made earlier" do
      Capybara.using_session(:employee) do
        sign_in order.employee

        visit display_orders_path
        expect(page).to have_content order.reward.price
        expect(order.reward.price).to eq price
      end

      Capybara.using_session(:admin_user) do
        sign_in admin_user

        visit admin_users_rewards_path
        click_link 'Edit'
        fill_in 'Price', with: new_price
        click_button 'Update'

        expect(page).to have_content 'Reward was successfully updated.'
        order.reward.reload
        expect(order.reward.price).to eq new_price
      end

      Capybara.using_session(:employee) do
        visit rewards_path
        expect(page).to have_content new_price

        click_link 'My Rewards'
        expect(page).to have_content price
        expect(page).not_to have_content new_price
        expect(order.reward.price).to eq new_price
      end
    end
  end

  context 'when filtering bought rewards list' do
    let!(:order2) { create(:order, employee: order.employee, status: :delivered) }

    it 'filters bought rewards list by status' do
      sign_in order.employee
      visit root_path

      click_link 'My Rewards'
      expect(page).to have_content order.reward.title
      expect(page).to have_content order2.reward.title
      expect(order.status).to eq 'not_delivered'
      expect(order2.status).to eq 'delivered'

      click_link 'Delivered rewards'
      expect(page).not_to have_content order.reward.title
      expect(page).to have_content order2.reward.title

      click_link 'Undelivered rewards'
      expect(page).to have_content order.reward.title
      expect(page).not_to have_content order2.reward.title

      click_link 'All rewards'
      expect(page).to have_content order.reward.title
      expect(page).to have_content order2.reward.title
    end
  end
end
