require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Modifying employees', type: :system do
  let(:admin_user) { create(:admin_user) }
  let!(:employee) { create(:employee) }

  before do
    driven_by(:rack_test)
    sign_in admin_user
  end

  context 'when listing all employees' do
    it 'enables to list' do
      expect(Employee.count).to eq 1

      visit '/admin/pages/dashboard'
      click_link 'Go to Employees Admin Panel'

      expect(page).to have_content employee.email
      expect(page).to have_content employee.number_of_available_kudos
    end

    it 'unenabled to list without log in' do
      sign_out admin_user
      visit '/admin/employees'

      expect(page).to have_content 'Admin log in'
    end
  end

  context 'when editing employee data' do
    it 'enables to change all data' do
      visit '/admin/employees'
      click_link 'Edit'

      fill_in 'Email', with: 'changed@mail.com'
      fill_in 'Password', with: 'password1'
      fill_in 'Number of kudos', with: 7

      click_button 'Update'

      expect(page).to have_content 'Employee was successfully updated.'
      expect(change(employee.email, :email)).to be_truthy
      expect(change(employee.password, :password)).to be_truthy
      expect(change(employee.number_of_available_kudos, :number_of_available_kudos)).to be_truthy
    end

    it 'enables to update without changing password' do
      visit '/admin/employees'
      click_link 'Edit'

      fill_in 'Email', with: 'changed@mail.com'
      fill_in 'Number of kudos', with: 7

      click_button 'Update'

      expect(page).to have_content 'Employee was successfully updated.'
      expect(change(employee.email, :email)).to be_truthy
      expect(change(employee.number_of_available_kudos, :number_of_available_kudos)).to be_truthy
    end
  end

  context 'when delete employee' do
    it 'enables to delete employee' do
      visit 'admin/employees'
      click_link 'Destroy'

      expect(page).to have_content 'Employee was successfully destroyed.'
      expect(change(Employee, :count).by(1)).to be_truthy
    end
  end
end
