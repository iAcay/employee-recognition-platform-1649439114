require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'All orders to CSV format', type: :system do
  let(:admin_user) { create(:admin_user) }

  before do
    driven_by(:rack_test)
    sign_in admin_user
  end

  context 'when converting orders to CSV format' do
    let!(:order1) { create(:order) }

    it 'generate CSV orders file' do
      visit dashboard_admin_users_pages_path
      click_link 'Manage Employees'

      click_link 'Export all orders to CSV'
      csv = CSV.parse(page.body)

      expected_headers = %w[ordered_on updated_at email title description price delivery_status]

      expect(csv).to have_content(expected_headers)
      expect(csv).to have_content order1.created_at.to_formatted_s(:db)
      expect(csv).to have_content order1.updated_at.to_formatted_s(:db)
      expect(csv).to have_content order1.employee.email
      expect(csv).to have_content order1.reward_snapshot.title
      expect(csv).to have_content order1.reward_snapshot.description
      expect(csv).to have_content order1.reward_snapshot.price
      expect(csv).to have_content order1.status
    end
  end
end
