require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Modifying kudos', type: :system do
  before do
    driven_by(:rack_test)
    create(:employee)
    create(:employee, email: 'receiver@example.com')
    visit 'employees/sign_in'
    fill_in 'Email', with: 'employee@example.com'
    fill_in 'Password', with: 'password321'
    click_button 'Log in'
  end

  context 'when modifying kudo' do
    it 'enables to modify a kudo' do
      # CREATING A NEW KUDO
      visit '/kudos/new'
      fill_in 'Title', with: 'Great Worker!!'
      fill_in 'Content', with: 'Three times faster than others!'
      click_button 'Create Kudo'

      expect(page).to have_content 'created'
      expect(change(Kudo, :count).by(1)).to be_truthy

      # EDITING A KUDO
      visit '/kudos'
      click_link 'Edit'
      fill_in 'Title', with: 'Super Worker!'
      click_button 'Update Kudo'

      expect(page).to have_content 'updated'

      # VALIDATION
      # create
      visit '/kudos/new'
      fill_in 'Title', with: 'Great Worker!'
      fill_in 'Content', with: ''
      click_button 'Create Kudo'

      expect(page).to have_content 'be blank'

      # edit
      visit '/kudos'
      click_link 'Edit'
      fill_in 'Title', with: ''
      click_button 'Update Kudo'

      expect(page).to have_content 'be blank'

      # DESTROYING A KUDO
      visit '/kudos'
      click_link 'Destroy'

      expect(page).to have_content 'destroyed'
      expect(change(Kudo, :count).by(1)).to be_truthy
    end
  end
end
