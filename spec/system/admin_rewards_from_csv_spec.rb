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
      visit dashboard_admin_users_pages_path
      click_link 'Manage Rewards'

      click_link 'Import rewards from CSV'
      attach_file Rails.root.join('./spec/fixtures/rewards/only_new_rewards_import.csv')
      click_button 'Import Rewards'

      expect(page).to have_content 'Rewards were successfully imported.'

      reward1 = Reward.find_by(title: 'RewardTitle', description: 'RewardDescription', price: 3,
                               delivery_method: 'post')
      expect(reward1.present?).to be true
      expect(reward1.category.title).to eq 'Category1'

      reward2 = Reward.find_by(title: 'RewardTitle2', description: 'RewardDescription2', price: 4,
                               delivery_method: 'online')
      expect(reward2.present?).to be true
      expect(reward2.category.title).to eq 'Category2'

      reward3 = Reward.find_by(title: 'RewardTitle3', description: 'RewardDescription3', price: 5,
                               delivery_method: 'pick_up')
      expect(reward3.present?).to be true
      expect(reward3.category.title).to eq 'Category3'

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
      expect(page).to have_content 'RewardTitle3'
      expect(page).to have_content 'RewardDescription3'
      expect(page).to have_content '5'
      expect(page).to have_content 'Pick Up'
      expect(page).to have_content 'Category3'
    end

    it 'creates new reward and updates existing one during import' do
      visit dashboard_admin_users_pages_path
      click_link 'Manage Rewards'

      click_link 'Import rewards from CSV'
      attach_file Rails.root.join('./spec/fixtures/rewards/only_new_rewards_import.csv')
      expect { click_button 'Import Reward' }.to change(Reward, :count).by(3)

      click_link 'Import rewards from CSV'
      attach_file Rails.root.join('./spec/fixtures/rewards/new_and_existing_rewards_import.csv')
      expect { click_button 'Import Reward' }.to change(Reward, :count).by(1)

      expect(page).to have_content 'Rewards were successfully imported.'
      expect(Reward.find_by(title: 'RewardTitle', description: 'ChangedRewardDescription', price: 4,
                            delivery_method: 'online').present?).to be true
      expect(Reward.find_by(title: 'RewardTitle').category.title).to eq 'ChangedCategory'
      reward4 = Reward.find_by(title: 'RewardTitle4', description: 'RewardDescription4', price: 5,
                               delivery_method: 'pick_up')
      expect(reward4.present?).to be true
      expect(reward4.category.title).to eq 'Category4'
      expect(page).to have_content 'RewardTitle'
      expect(page).to have_content 'ChangedRewardDescription'
      expect(page).to have_content '4'
      expect(page).to have_content 'Online'
      expect(page).to have_content 'ChangedCategory'
      expect(page).to have_content 'RewardTitle4'
      expect(page).to have_content 'RewardDescription4'
      expect(page).to have_content '5'
      expect(page).to have_content 'Pick Up'
      expect(page).to have_content 'Category4'
    end

    it 'checks validations while importing rewards from csv' do
      visit dashboard_admin_users_pages_path
      click_link 'Manage Rewards'

      click_link 'Import rewards from CSV'
      attach_file Rails.root.join('./spec/fixtures/rewards/invalid_rewards_import.csv')
      expect { click_button 'Import Rewards' }.not_to change(Reward, :count)

      expect(page).to have_content "Validation failed: Title can't be blank, " \
                                   "Description can't be blank, Delivery method can't be blank, " \
                                   'Price is not a number'
    end
  end
end
