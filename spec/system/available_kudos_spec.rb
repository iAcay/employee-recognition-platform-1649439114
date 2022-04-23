require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Available number of kudos', type: :system do
  let(:employee) { create(:employee) }

  before do
    driven_by(:rack_test)
    create(:employee, email: 'receiver@example.com')
    sign_in employee
  end

  context 'when creating a kudo' do
    it 'proper number of available kudos' do
      # AFTER CREATING ONE KUDO
      visit root_path
      create_new_kudo

      expect(page).to have_content 'Available: 9'
      expect(change(Kudo, :count).by(1)).to be_truthy

      # AFTER CREATING TEN KUDOS
      9.times do
        create_new_kudo
      end

      expect(page).to have_content 'Available: 0'
      expect(Kudo.count).to eq 10
    end

    it 'maximum number of available kudos' do
      visit root_path
      10.times do
        create_new_kudo
      end

      expect(page).to have_content 'Available: 0'

      click_link 'New Kudo'

      expect(page).to have_content 'You cannot add more kudos.'
      expect(Kudo.count).to eq 10
    end
  end
end

def create_new_kudo
  click_link 'New Kudo'
  fill_in 'Title', with: 'Great Worker!!'
  fill_in 'Content', with: 'Three times faster than others!'
  click_button 'Create Kudo'
end
