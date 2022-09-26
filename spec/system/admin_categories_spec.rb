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
      fill_in 'Title', with: category.title
      expect { click_button 'Create' }.to change(Category, :count).by(1)
      expect(page).to have_content 'Category was successfully created.'
    end

    it 'checks validation notices' do
      fill_in 'Title', with: ''
      expect { click_button 'Create' }.not_to change(Category, :count)
      expect(page).to have_content "Title can't be blank"
    end
  end

  context 'when editing a category' do
    let!(:category) { create(:category) }

    before do
      visit dashboard_admin_users_pages_path
      click_link 'Manage Categories'
      click_link 'Edit'
    end

    it 'edits a category' do
      fill_in 'Title', with: 'ChangedCategory'
      click_button 'Update'

      category.reload
      expect(page).to have_content 'Category was successfully updated.'
      expect(category.title).to eq 'ChangedCategory'
    end

    it 'checks validation notices' do
      fill_in 'Title', with: ''
      click_button 'Update'

      expect(page).to have_content "Title can't be blank"
    end
  end

  context 'when deleting a category' do
    let!(:category) { create(:category) }

    it 'removes a category' do
      visit dashboard_admin_users_pages_path
      click_link 'Manage Categories'

      expect { click_link 'Destroy' }.to change(Category, :count).by(-1)
      expect(page).to have_content 'Category was successfully destroyed.'
    end

    it 'does not remove a category which is related to reward' do
      create(:reward, category: category)

      visit dashboard_admin_users_pages_path
      click_link 'Manage Categories'

      expect { click_link 'Destroy' }.not_to change(Category, :count)
      expect(page).to have_content 'This category cannot be deleted because of its relations with existing rewards.'
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
