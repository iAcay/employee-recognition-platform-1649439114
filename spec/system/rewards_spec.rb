require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Working on rewards', type: :system do
  let(:employee) { create(:employee) }
  let!(:reward) { create(:reward) }

  before do
    driven_by(:rack_test)
    sign_in employee
  end

  context 'when listing all rewards' do
    it 'enables to list all rewards with their title and price without description' do
      expect(Reward.count).to eq 1

      visit root_path
      click_link 'Rewards'

      expect(page).to have_content reward.title
      expect(page).to have_content reward.price
      expect(page).not_to have_content reward.description
      expect(page).to have_link 'Show'
    end
  end

  context 'when showing a particular reward' do
    it 'enables to show a specific reward with all of its details' do
      visit '/rewards'
      click_link 'Show'

      expect(page).to have_content reward.title
      expect(page).to have_content reward.price
      expect(page).to have_content reward.description
    end
  end
end
