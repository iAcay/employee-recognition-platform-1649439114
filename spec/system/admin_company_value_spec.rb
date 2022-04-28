require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Modifying company values', type: :system do
  let(:admin_user) { create(:admin_user) }
  let!(:company_value) { create(:company_value) }

  before do
    driven_by(:rack_test)
    sign_in admin_user
  end

  context 'when creating a new company value' do
    it 'enables to create a new company value' do
      expect(CompanyValue.count).to eq 1

      go_to_form_new_company_value

      fill_in 'Title', with: 'First Title'
      click_button 'Update'

      expect(CompanyValue.count).to eq 2
      expect(page).to have_content 'Company Value was successfully created.'
    end

    it 'checks validation notices' do
      expect(CompanyValue.count).to eq 1

      go_to_form_new_company_value

      fill_in 'Title', with: ''
      click_button 'Update'

      expect(CompanyValue.count).to eq 1
      expect(page).to have_content "Title can't be blank"

      fill_in 'Title', with: company_value.title
      click_button 'Update'

      expect(CompanyValue.count).to eq 1
      expect(page).to have_content 'Title has already been taken'
    end

    def go_to_form_new_company_value
      visit '/admin/pages/dashboard'
      click_link 'Go to Company Values Admin Panel'
      click_link 'New Company Value'
    end
  end

  context 'when listing all company values' do
    it 'enables to list all company values' do
      company_value2 = create(:company_value, title: 'Second Company Value')

      expect(CompanyValue.count).to eq 2

      visit '/admin/company_values'

      expect(page).to have_content company_value.title
      expect(page).to have_content company_value2.title
      expect(page).to have_content 'Edit'
      expect(page).to have_content 'Destroy'
    end

    it 'unenabled to list without log in' do
      sign_out admin_user
      visit '/admin/company_values'

      expect(page).to have_content 'Admin log in'
    end
  end

  context 'when editing company value' do
    it 'enables to edit a company value' do
      visit '/admin/pages/dashboard'
      click_link 'Go to Company Values Admin Panel'

      expect(page).to have_content company_value.title
      expect(company_value.title).to eq 'Random Title'

      click_link 'Edit'
      fill_in 'Title', with: 'New Title of Company Value'
      click_button 'Update'

      company_value.reload
      expect(page).to have_content 'Company Value was successfully updated.'
      expect(company_value.title).to eq 'New Title of Company Value'
    end
  end

  context 'when deleting company value' do
    it 'enables to delete company value' do
      expect(CompanyValue.count).to eq 1

      visit '/admin/pages/dashboard'
      click_link 'Go to Company Values Admin Panel'

      click_link 'Destroy'

      expect(page).to have_content 'Company Value was successfully destroyed.'
      expect(CompanyValue.count).to eq 0
    end
  end
end
