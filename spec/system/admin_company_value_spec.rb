require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Admin Company Values CRUD', type: :system do
  let(:admin_user) { create(:admin_user) }
  let!(:company_value) { create(:company_value) }

  before do
    driven_by(:rack_test)
    sign_in admin_user
  end

  context 'when creating a new company value' do
    def go_to_form_new_company_value
      visit '/admin/pages/dashboard'
      click_link 'Manage Company Values'
      click_link 'New Company Value'
    end

    it 'enables to create a new company value' do
      go_to_form_new_company_value

      fill_in 'Title', with: 'First Title'
      expect { click_button 'Create' }.to change(CompanyValue, :count).by(1)
      expect(page).to have_content 'Company Value was successfully created.'
    end

    it 'checks validation notices' do
      go_to_form_new_company_value

      fill_in 'Title', with: ''
      expect { click_button 'Create' }.not_to change(CompanyValue, :count)
      expect(page).to have_content "Title can't be blank"

      fill_in 'Title', with: company_value.title
      expect { click_button 'Create' }.not_to change(CompanyValue, :count)
      expect(page).to have_content 'Title has already been taken'
    end
  end

  context 'when listing all company values' do
    it 'enables to list all company values' do
      company_value2 = create(:company_value, title: 'Second Company Value')

      visit '/admin/company_values'

      expect(page).to have_content company_value.title
      expect(page).to have_content company_value2.title
      expect(page).to have_content 'Edit'
      expect(page).to have_content 'Destroy'
    end

    it 'does not allow to access page without loggin in as an admin' do
      sign_out admin_user
      visit '/admin/company_values'

      expect(page).to have_content 'Admin log in'
    end
  end

  context 'when editing company value' do
    it 'enables to edit a company value' do
      visit '/admin/pages/dashboard'
      click_link 'Manage Company Values'

      expect(page).to have_content company_value.title
      expect(company_value.title).to eq 'Company Value Title'

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
      visit '/admin/pages/dashboard'
      click_link 'Manage Company Values'

      expect { click_link 'Destroy' }.to change(CompanyValue, :count).by(-1)
      expect(page).to have_content 'Company Value was successfully destroyed.'
    end
  end
end
