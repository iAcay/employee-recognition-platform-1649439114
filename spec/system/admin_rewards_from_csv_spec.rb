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
      attach_file(File.absolute_path('./spec/fixtures/rewards/only_new_rewards_import.csv'))
      click_button 'Import Rewards'

      expect(page).to have_content 'Rewards were successfully imported.'
      expect(Reward.count).to eq 2
      expect(Reward.first.title).to eq 'RewardTitle'
      expect(Reward.first.description).to eq 'RewardDescription'
      expect(Reward.first.price).to eq 3
      expect(Reward.first.delivery_method).to eq 'post'
      expect(Reward.first.category.title).to eq 'Category1'
      expect(Reward.last.title).to eq 'RewardTitle2'
      expect(Reward.last.description).to eq 'RewardDescription2'
      expect(Reward.last.price).to eq 4
      expect(Reward.last.delivery_method).to eq 'online'
      expect(Reward.last.category.title).to eq 'Category2'
      expect(page).to have_content 'RewardTitle'
      expect(page).to have_content 'RewardDescription'
      expect(page).to have_content '3'
      expect(page).to have_content 'Post'
      expect(page).to have_content 'Category1'
      expect(page).to have_content 'RewardTitle2'
      expect(page).to have_content 'RewardDescription2'
      expect(page).to have_content '4'
      expect(page).to have_content 'Online'
      expect(page).to have_content 'Category2'
    end

    it 'creates new reward and updates existing one during import' do
      expect(Reward.count).to eq 0
      visit dashboard_admin_users_pages_path
      click_link 'Manage Rewards'

      click_link 'Import rewards from CSV'
      attach_file(File.absolute_path('./spec/fixtures/rewards/only_new_rewards_import.csv'))
      click_button 'Import Rewards'
      expect(Reward.count).to eq 2

      click_link 'Import rewards from CSV'
      attach_file(File.absolute_path('./spec/fixtures/rewards/new_and_existing_rewards_import.csv'))
      click_button 'Import Rewards'

      expect(page).to have_content 'Rewards were successfully imported.'
      expect(Reward.count).to eq 3
      expect(Reward.first.title).to eq 'RewardTitle'
      expect(Reward.first.description).to eq 'ChangedRewardDescription'
      expect(Reward.first.price).to eq 4
      expect(Reward.first.delivery_method).to eq 'online'
      expect(Reward.first.category.title).to eq 'ChangedCategory'
      expect(Reward.last.title).to eq 'RewardTitle3'
      expect(Reward.last.description).to eq 'RewardDescription3'
      expect(Reward.last.price).to eq 7
      expect(Reward.last.delivery_method).to eq 'post'
      expect(Reward.last.category.title).to eq 'Category3'
      expect(page).to have_content 'RewardTitle'
      expect(page).to have_content 'ChangedRewardDescription'
      expect(page).to have_content '4'
      expect(page).to have_content 'Online'
      expect(page).to have_content 'ChangedCategory'
      expect(page).to have_content 'RewardTitle3'
      expect(page).to have_content 'RewardDescription2'
      expect(page).to have_content '7'
      expect(page).to have_content 'Post'
      expect(page).to have_content 'Category3'
    end

    it 'checks validations while importing rewards from csv' do
      expect(Reward.count).to eq 0
      visit dashboard_admin_users_pages_path
      click_link 'Manage Rewards'

      click_link 'Import rewards from CSV'
      attach_file(File.absolute_path('./spec/fixtures/rewards/invalid_rewards_import.csv'))
      click_button 'Import Rewards'

      expect(page).to have_content "Validation failed: Title can't be blank, " \
                                   "Description can't be blank, Delivery method can't be blank, " \
                                   'Price is not a number'
      expect(Reward.count).to eq 0
    end
  end
end
