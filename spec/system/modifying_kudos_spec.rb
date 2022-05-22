require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Working on kudos', type: :system do
  let(:employee) { create(:employee) }

  before do
    driven_by(:rack_test)
    create(:employee, email: 'receiver@example.com')
    sign_in employee
  end

  context 'when creating a kudo' do
    it 'enables to create a kudo' do
      visit root_path
      click_link 'New Kudo'

      fill_in 'Title', with: 'Great Worker!!'
      fill_in 'Content', with: 'Three times faster than others!'
      click_button 'Create Kudo'

      expect(page).to have_content 'Kudo was successfully created.'
      expect(Kudo.count).to eq 1
    end

    it 'checks validation' do
      visit root_path
      click_link 'New Kudo'

      fill_in 'Title', with: ''
      fill_in 'Content', with: ''
      click_button 'Create Kudo'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Content can't be blank"
    end
  end

  context 'when editing a kudo' do
    it 'enables to edit a kudo' do
      kudo = create(:kudo, giver: employee)
      visit root_path
      click_link 'Edit'

      fill_in 'Title', with: 'Super Worker!'
      fill_in 'Content', with: 'He works with really good attitude!'
      click_button 'Update Kudo'

      kudo.reload
      expect(page).to have_content 'Kudo was successfully updated.'
      expect(kudo.title).to eq 'Super Worker!'
      expect(kudo.content).to eq 'He works with really good attitude!'
    end

    it 'checks validation' do
      create(:kudo, giver: employee)
      visit root_path
      click_link 'Edit'

      fill_in 'Title', with: ''
      fill_in 'Content', with: ''
      click_button 'Update Kudo'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Content can't be blank"
    end

    it 'checks authorization' do
      kudo = create(:kudo)
      visit root_path

      expect(page).to have_content 'Unauthorized'

      visit "kudos/#{kudo.id}/edit"

      expect(page).to have_content 'Not authorized to edit this Kudo.'
    end
  end

  context 'when destroying a kudo' do
    let!(:kudo) { create(:kudo, giver: employee) }

    it 'enables to destroy a kudo' do
      visit root_path
      click_link 'Destroy'

      expect(page).to have_content 'Kudo was successfully destroyed.'
      expect(Kudo.count).to eq 0
    end
  end
end
