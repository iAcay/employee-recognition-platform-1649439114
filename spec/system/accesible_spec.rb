require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Accesible tests', type: :system do
  let(:admin_user) { create(:admin_user) }
  let(:employee) { create(:employee) }

  before do
    driven_by(:rack_test)
  end

  context 'when logged in as an admin' do
    it "can't access employees signin page" do
      sign_in admin_user
      visit 'employees/sign_in'

      expect(page).to have_content 'You cannot be logged in as an admin.'
      expect(page).to have_content 'Admin dashboard'
    end

    it "can't access employee signup page" do
      sign_in admin_user
      visit 'employees/sign_up'

      expect(page).to have_content 'You cannot be logged in as an admin.'
      expect(page).to have_content 'Admin dashboard'
    end
  end

  context 'when logged in as an employee' do
    it "can't access admin signin page" do
      sign_in employee
      visit '/admin'

      expect(page).to have_content 'You cannot be logged in as an employee.'
      expect(page).to have_content 'Kudos'
    end
  end
end
