require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Categories', type: :system do
  let(:admin_user) { create(:admin_user) }

  before do
    driven_by(:rack_test)
    sign_in admin_user
  end

  context 'when creating a new category' do
    let(:category) { build(:category) }

    before do
      visit dashboard_admin_users_pages_path
      click_link 'Manage Categories'
      click_link 'New Category'
    end

    it 'creates a new category' do
      expect(Category.count).to eq 0

      fill_in 'Title', with: category.title
      click_button 'Create'

      expect(Category.count).to eq 1
      expect(page).to have_content 'Category was successfully created.'
    end

    it 'checks validation notices' do
      expect(Category.count).to eq 0

      fill_in 'Title', with: ''
      click_button 'Create'

      expect(Category.count).to eq 0
      expect(page).to have_content "Title can't be blank"
    end
  end

  context 'when adding category to a reward' do
    let!(:reward) { create(:reward) }
    let!(:category) { create(:category) }

    it 'adds category to a reward' do
      expect(reward.category).to eq nil

      visit dashboard_admin_users_pages_path
      click_link 'Manage Rewards'
      click_link 'Edit'

      select category.title, from: 'Category'
      click_button 'Update'

      reward.reload
      expect(reward.category).to eq category
    end
  end
end
