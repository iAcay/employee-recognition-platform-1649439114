require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Signing', type: :system do
  before do
    driven_by(:rack_test)
  end

  context 'when sign in and sign out' do
    let(:employee) { create(:employee) }

    it 'enables to sign in' do
      visit root_path
      click_link 'Sign in'
      fill_in 'Email', with: employee.email
      fill_in 'Password', with: employee.password
      click_button 'Log in'

      expect(page).to have_content 'Signed in successfully.'

      click_link 'Sign out'

      expect(page).to have_content 'Signed out successfully.'
    end
  end

  context 'when sign up' do
    let(:employee) { build(:employee) }

    it 'enables to sign up' do
      visit root_path
      click_link 'Sign up'
      fill_in 'First Name', with: employee.first_name
      fill_in 'Last Name', with: employee.last_name
      fill_in 'Email', with: employee.email
      fill_in 'Password', with: employee.password
      fill_in 'Password confirmation', with: employee.password
      click_button 'Sign up'

      expect(page).to have_content 'Welcome! You have signed up successfully.'
      expect(Employee.count).to eq 1
    end
  end
end
