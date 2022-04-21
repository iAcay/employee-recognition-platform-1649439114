require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Signing admin', type: :system do
  let(:admin_user) { create(:admin_user) }

  before do
    driven_by(:rack_test)
  end

  context 'when sign in and sign out' do
    it 'enables to sign in and sign out' do
      # ADMIN SIGN IN
      visit '/admin'
      fill_in 'Email', with: admin_user.email
      fill_in 'Password', with: admin_user.password
      click_button 'Log in'

      expect(page).to have_content 'Signed in'

      # ADMIN SIGN OUT
      click_link 'Sign out'

      expect(page).to have_content 'Signed out'
    end
  end
end
