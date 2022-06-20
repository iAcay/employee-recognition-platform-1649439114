require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Admin orders listing', type: :system do
  let(:admin_user) { create(:admin_user) }
  let!(:order1) { create(:order) }
  let!(:order2) { create(:order) }

  before do
    driven_by(:rack_test)
    sign_in admin_user
  end

  context 'when listing all rewards bought by one employee' do
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
end
