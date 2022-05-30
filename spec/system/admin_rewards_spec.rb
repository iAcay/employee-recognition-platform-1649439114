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
      click_link 'Go to Rewards Admin Panel'
      click_link 'New Reward'
    end

    it 'enables to create a new reward' do
      expect(Reward.count).to eq 0

      fill_in 'Title', with: reward.title
      fill_in 'Description', with: reward.description
      fill_in 'Price', with: reward.price
      click_button 'Create'

      expect(Reward.count).to eq 1
      expect(page).to have_content 'Reward was successfully created.'
    end

    it 'checks validation notices' do
      expect(Reward.count).to eq 0

      fill_in 'Title', with: ''
      fill_in 'Description', with: ''
      # CHECK NOTICE WHEN PRICE IS SET ON LESS THAN 1
      fill_in 'Price', with: 0.0
      click_button 'Create'

      expect(Reward.count).to eq 0
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Description can't be blank"
      expect(page).to have_content 'Price must be greater than or equal to 1'

      # CHECK NOTICE WHEN PRICE IS NOT A NUMBER
      fill_in 'Price', with: 'random'
      click_button 'Create'

      expect(Reward.count).to eq 0
      expect(page).to have_content 'Price is not a number'
    end
  end

  context 'when listing all rewards' do
    it 'enables to list all rewards' do
      reward = create(:reward)

      expect(Reward.count).to eq 1

      visit '/admin/rewards'

      expect(page).to have_content reward.title
      expect(page).to have_content reward.description
      expect(page).to have_content '$1'
      expect(page).to have_content 'Edit'
      expect(page).to have_content 'Destroy'
    end
  end

  context 'when editing reward' do
    let!(:reward) { create(:reward) }

    it 'enables to edit a reward' do
      visit '/admin/pages/dashboard'
      click_link 'Go to Rewards Admin Panel'

      click_link 'Edit'
      fill_in 'Title', with: 'New Title of Reward'
      fill_in 'Description', with: 'New Description of Reward'
      fill_in 'Price', with: 120.0
      click_button 'Update'

      reward.reload
      expect(page).to have_content 'Reward was successfully updated.'
      expect(reward.title).to eq 'New Title of Reward'
      expect(reward.description).to eq 'New Description of Reward'
      # Check if the new reward price is equal to 12.000 cents.
      expect(reward.price).to eq Money.new(12_000)
    end
  end

  context 'when deleting reward' do
    let!(:reward) { create(:reward) }

    it 'enables to delete reward' do
      expect(Reward.count).to eq 1

      visit '/admin/pages/dashboard'
      click_link 'Go to Rewards Admin Panel'

      click_link 'Destroy'

      expect(page).to have_content 'Reward was successfully deleted.'
      expect(Reward.count).to eq 0
    end
  end
end
