require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Modifying employees data', type: :system do
  let(:first_number_of_kudos) { 7 }
  let(:second_number_of_kudos) { 10 }
  let(:admin_user) { create(:admin_user) }
  let!(:employee) { create(:employee, number_of_available_kudos: first_number_of_kudos) }

  before do
    driven_by(:rack_test)
    sign_in admin_user
  end

  context 'when listing all employees' do
    it 'enables to list' do
      visit '/admin/pages/dashboard'
      click_link 'Manage Employees'

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

      fill_in 'First Name', with: 'ChangedFirstName'
      fill_in 'Last Name', with: 'ChangedLastName'
      fill_in 'Email', with: 'changed@mail.com'
      fill_in 'Password', with: 'password1'
      fill_in 'Number of kudos', with: second_number_of_kudos
      click_button 'Update'

      employee.reload
      expect(page).to have_content 'Employee was successfully updated.'
      expect(employee.first_name).to eq 'ChangedFirstName'
      expect(employee.last_name).to eq 'ChangedLastName'
      expect(employee.email).to eq 'changed@mail.com'
      expect(employee.valid_password?('password1')).to be true
      expect(employee.number_of_available_kudos).to eq second_number_of_kudos
    end

    it 'enables to update without changing password' do
      visit '/admin/employees'
      click_link 'Edit'

      fill_in 'Email', with: 'changed@mail.com'
      fill_in 'Number of kudos', with: second_number_of_kudos
      click_button 'Update'

      employee.reload
      expect(page).to have_content 'Employee was successfully updated.'
      expect(employee.email).to eq 'changed@mail.com'
      expect(employee.number_of_available_kudos).to eq second_number_of_kudos
    end

    it "checks validation when editing all employee's data" do
      visit '/admin/employees'
      click_link 'Edit'

      employee2 = create(:employee)

      fill_in 'First Name', with: ''
      fill_in 'Last Name', with: ''
      fill_in 'Email', with: employee2.email
      fill_in 'Password', with: '123'
      click_button 'Update'

      expect(page).to have_content "First name can't be blank"
      expect(page).to have_content "Last name can't be blank"
      expect(page).to have_content 'Email has already been taken'
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end

    it "checks validation when editing employee's data without password" do
      visit admin_users_employees_path
      click_link 'Edit'

      employee2 = create(:employee)

      fill_in 'First Name', with: ''
      fill_in 'Last Name', with: ''
      fill_in 'Email', with: employee2.email
      click_button 'Update'

      expect(page).to have_content "First name can't be blank"
      expect(page).to have_content "Last name can't be blank"
      expect(page).to have_content 'Email has already been taken'
    end
  end

  context 'when deleting employee' do
    it 'enables to delete employee' do
      visit 'admin/employees'
      expect { click_link 'Destroy' }.to change(Employee, :count).by(-1)
      expect(page).to have_content 'Employee was successfully destroyed.'
    end
  end

  context 'when incrementing number of available kudos for all employees' do
    let!(:employee1) { create(:employee, number_of_available_kudos: first_number_of_kudos) }

    it 'increments number of available kudos for all employees' do
      expect(employee.number_of_available_kudos).to eq first_number_of_kudos
      expect(employee1.number_of_available_kudos).to eq first_number_of_kudos

      visit '/admin/pages/dashboard'
      click_link 'Add Kudos'

      fill_in 'Number of kudos', with: second_number_of_kudos
      click_button 'Add Kudos'

      expect(page).to have_content "Each employee received #{second_number_of_kudos} additional kudos for use."

      employee.reload
      employee1.reload
      expect(employee.number_of_available_kudos).to eq(first_number_of_kudos + second_number_of_kudos)
      expect(employee1.number_of_available_kudos).to eq(first_number_of_kudos + second_number_of_kudos)
    end

    it 'checks validation when given number of available is not between 1 to 20' do
      visit dashboard_admin_users_pages_path
      click_link 'Add Kudos'
      fill_in 'Number of kudos', with: 30
      expect { click_button 'Add Kudos' }.not_to change { employee.reload.number_of_available_kudos }
      expect(page).to have_content 'Given number is not valid, please enter a number between 1 to 20.'
    end
  end
end
