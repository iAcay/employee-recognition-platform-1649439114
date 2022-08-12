require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Import rewards from a CSV', type: :system do
  let(:admin_user) { create(:admin_user) }

  before do
    driven_by(:rack_test)
    sign_in admin_user
  end

  context 'when importing rewards from csv file' do
    it 'imports reward from csv file' do
      expect(Reward.count).to eq 0
      visit dashboard_admin_users_pages_path
      click_link 'Manage Rewards'

      click_link 'Import rewards from CSV'
      attach_file(File.absolute_path('./spec/files/test1.csv'))
      click_button 'Import Rewards'

      expect(page).to have_content 'Rewards were successfully imported.'
      expect(Reward.count).to eq 1
      expect(Reward.first.title).to eq 'RewardTitle'
      expect(Reward.first.description).to eq 'RewardDescription'
      expect(Reward.first.price).to eq 3
      expect(Reward.first.category.title).to eq 'Category1'
      expect(page).to have_content 'RewardTitle'
      expect(page).to have_content 'RewardDescription'
      expect(page).to have_content '3'
      expect(page).to have_content 'Category1'

      # WHEN REWARD WITH IMPORTED TITLE EXISTS ITS DESCRIPTION, PRICE AND CATEGORY SHOULD BE UPDATED

      click_link 'Import rewards from CSV'
      attach_file(File.absolute_path('./spec/files/test2.csv'))
      click_button 'Import Rewards'

      expect(page).to have_content 'Rewards were successfully imported.'
      expect(Reward.count).to eq 1
      expect(Reward.first.title).to eq 'RewardTitle'
      expect(Reward.first.description).to eq 'RewardDescription2'
      expect(Reward.first.price).to eq 4
      expect(Reward.first.category.title).to eq 'Category2'
      expect(page).to have_content 'RewardTitle'
      expect(page).to have_content 'RewardDescription2'
      expect(page).to have_content '4'
      expect(page).to have_content 'Category2'
    end

    it 'checks validations while importing rewards from csv' do
      expect(Reward.count).to eq 0
      visit dashboard_admin_users_pages_path
      click_link 'Manage Rewards'

      click_link 'Import rewards from CSV'
      attach_file(File.absolute_path('./spec/files/test3.csv'))
      click_button 'Import Rewards'

      expect(page).to have_content "Errors in CSV file: Validation failed: Title can't be blank, " \
                                   "Description can't be blank, Price is not a number."
      expect(Reward.count).to eq 0
    end
  end
end
