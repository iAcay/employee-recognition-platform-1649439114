require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Available number of kudos', type: :system do
  let!(:employee) { create(:employee) }

  before do
    driven_by(:rack_test)
    create(:employee, email: 'receiver@example.com')
    sign_in employee
  end

  context 'when creating a kudo' do
    let!(:company_value) { create(:company_value) }
    let(:kudo) { build(:kudo) }

    it 'proper number of available kudos after creating a kudo' do
      visit root_path
      click_link 'New Kudo'
      fill_in 'Title', with: kudo.title
      fill_in 'Content', with: kudo.content
      select company_value.title, from: 'Company value'
      click_button 'Create Kudo'

      employee.reload
      expect(page).to have_content 'Available kudos: 9'
      expect(employee.number_of_available_kudos).to eq 9
    end
  end

  context 'when number of available kudos is equal to 0' do
    before do
      employee.update(number_of_available_kudos: 0)
    end

    it 'maximum number of available kudos' do
      visit root_path
      expect(page).to have_content 'Available kudos: 0'

      click_link 'New Kudo'
      expect(page).to have_content 'You cannot add more kudos.'
    end
  end
end
