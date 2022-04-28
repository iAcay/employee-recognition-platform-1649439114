require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Accesible tests', type: :system do
  let(:admin_user) { create(:admin_user) }
  let(:employee) { create(:employee) }

  before do
    driven_by(:rack_test)
  end

  context 'when as an admin' do
    it 'unenabled to sign in as an employee' do
      sign_in admin_user
      visit 'employees/sign_in'

      expect(page).to have_content 'You cannot be logged in as an admin.'
      expect(page).to have_content 'Admin dashboard'
    end

    it 'unenabled to sign up as an employee' do
      sign_in admin_user
      visit 'employees/sign_up'

      expect(page).to have_content 'You cannot be logged in as an admin.'
      expect(page).to have_content 'Admin dashboard'
    end
  end

  context 'when as an employee' do
    it 'unenabled to sign in as an admin' do
      sign_in employee
      visit '/admin'

      expect(page).to have_content 'You cannot be logged in as an employee.'
      expect(page).to have_content 'Kudos'
    end
  end
end
