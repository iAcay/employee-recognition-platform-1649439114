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

      employee.reload

      expect(page).to have_content 'Employee was successfully updated.'
      expect(employee.email).to eq 'changed@mail.com'
      expect(employee.number_of_available_kudos).to eq 7
    end

    it 'enables to update without changing password' do
      visit '/admin/employees'
      click_link 'Edit'

      fill_in 'Email', with: 'changed@mail.com'
      fill_in 'Number of kudos', with: 7

      click_button 'Update'

      employee.reload

      expect(page).to have_content 'Employee was successfully updated.'
      expect(employee.email).to eq 'changed@mail.com'
      expect(employee.number_of_available_kudos).to eq 7
    end

    it 'checks validation' do
      visit '/admin/employees'
      click_link 'Edit'

      employee2 = create(:employee)

      fill_in 'Email', with: employee2.email
      fill_in 'Password', with: '123'

      click_button 'Update'

      expect(page).to have_content 'Email has already been taken'
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end
  end

  context 'when deleting employee' do
    it 'enables to delete employee' do
      visit 'admin/employees'
      click_link 'Destroy'

      expect(page).to have_content 'Employee was successfully destroyed.'
      expect(Employee.count).to eq 0
    end
  end
end
