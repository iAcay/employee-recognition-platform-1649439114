require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Signing', type: :system do
  before do
    driven_by(:rack_test)
  end

  # SIGNING IN
  context 'when sign in and sign out' do
    it 'enables to sign in' do
      create(:employee)

      visit root_path
      click_link 'Sign in'
      fill_in 'Email', with: 'employee@example.com'
      fill_in 'Password', with: 'password321'
      click_button 'Log in'

      expect(page).to have_content 'Signed in'

      click_link 'Sign out'

      expect(page).to have_content 'Signed out'
    end
  end

  # SIGNING UP
  context 'when sign up' do
    it 'enables to sign up' do
      visit root_path
      click_link 'Sign up'
      fill_in 'Email', with: 'signuptest@test.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_button 'Sign up'

      expect(page).to have_content 'Welcome!'
      expect(change(Employee, :count).by(1)).to be_truthy
    end
  end
end
