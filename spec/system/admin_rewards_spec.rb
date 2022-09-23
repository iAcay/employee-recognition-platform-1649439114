require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Admin Rewards CRUD', type: :system do
  let(:admin_user) { create(:admin_user) }
  let!(:reward) { build(:reward) }

  before do
    driven_by(:rack_test)
    sign_in admin_user
  end

  context 'when creating a new reward' do
    before do
      visit '/admin/pages/dashboard'
      click_link 'Manage Rewards'
      click_link 'New Reward'
    end

    it 'enables to create a new reward' do
      fill_in 'Title', with: reward.title
      fill_in 'Description', with: reward.description
      fill_in 'Price', with: reward.price
      expect { click_button 'Create' }.to change(Reward, :count).by(1)
      expect(page).to have_content 'Reward was successfully created.'
    end

    it 'checks validation notices' do
      fill_in 'Title', with: ''
      fill_in 'Description', with: ''
      # CHECK NOTICE WHEN PRICE IS SET ON LESS THAN 1
      fill_in 'Price', with: 0
      expect { click_button 'Create' }.not_to change(Reward, :count)
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Description can't be blank"
      expect(page).to have_content 'Price must be greater than or equal to 1'

      # CHECK NOTICE WHEN PRICE IS NOT A NUMBER
      fill_in 'Price', with: 'random'
      click_button 'Create'
      expect(page).to have_content 'Price is not a number'
    end
  end

  context 'when listing all rewards' do
    it 'enables to list all rewards' do
      reward = create(:reward)
      visit '/admin/rewards'

      expect(page).to have_content reward.title
      expect(page).to have_content reward.description
      expect(page).to have_content reward.price
      expect(page).to have_content 'Edit'
      expect(page).to have_content 'Destroy'
    end

    it 'shows particular reward' do
      reward = create(:reward)
      visit dashboard_admin_users_pages_path
      click_link 'Manage Rewards'
      click_link 'Show'

      expect(page).to have_content reward.title
      expect(page).to have_content reward.description
      expect(page).to have_content reward.price
      expect(page).to have_content reward.display_category
      expect(page).to have_content reward.delivery_method.titleize
      expect(page).to have_link 'Edit'
      expect(page).to have_link 'Back'
    end
  end

  context 'when editing reward' do
    let!(:reward) { create(:reward) }

    it 'enables to edit a reward' do
      visit '/admin/pages/dashboard'
      click_link 'Manage Rewards'

      click_link 'Edit'
      fill_in 'Title', with: 'New Title of Reward'
      fill_in 'Description', with: 'New Description of Reward'
      fill_in 'Price', with: 120
      click_button 'Update'

      reward.reload
      expect(page).to have_content 'Reward was successfully updated.'
      expect(reward.title).to eq 'New Title of Reward'
      expect(reward.description).to eq 'New Description of Reward'
      expect(reward.price).to eq 120
    end

    it 'checks validations' do
      visit '/admin/pages/dashboard'
      click_link 'Manage Rewards'

      click_link 'Edit'
      fill_in 'Title', with: ''
      fill_in 'Description', with: ''
      fill_in 'Price', with: ''
      click_button 'Update'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Description can't be blank"
      expect(page).to have_content "Price can't be blank"
      expect(page).to have_content 'Price is not a number'
    end
  end

  context 'when adding photo to reward' do
    it 'enables to add photo to reward' do
      reward = create(:reward)

      visit '/admin/pages/dashboard'
      click_link 'Manage Rewards'
      click_link 'Edit'
      attach_file 'Photo', './spec/fixtures/rewards/test_image.jpeg'
      click_button 'Update'

      reward.reload
      expect(reward.photo).to be_attached
    end
  end

  context 'when deleting reward' do
    let!(:reward) { create(:reward) }

    it 'enables to delete reward' do
      visit '/admin/pages/dashboard'
      click_link 'Manage Rewards'

      expect { click_link 'Destroy' }.to change(Reward, :count).by(-1)
      expect(page).to have_content 'Reward was successfully deleted.'
    end
  end
end
