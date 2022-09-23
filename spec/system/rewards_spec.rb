require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Working on rewards', type: :system do
  let(:employee) { create(:employee) }
  let!(:reward) { create(:reward) }
  let!(:online_code) { create(:online_code, reward: reward) }

  before do
    driven_by(:rack_test)
    sign_in employee
  end

  context 'when listing all rewards' do
    it 'enables to list all rewards with their title and price without description' do
      visit root_path
      click_link 'Rewards'

      expect(page).to have_content reward.title
      expect(page).to have_content reward.price
      expect(page).not_to have_content reward.description
      expect(page).to have_link 'Show'
    end
  end

  context 'when paginating rewards' do
    it 'does not show pagination links if the number of rewards is less than 3' do
      visit rewards_path
      within('div.flickr_pagination') do
        expect(page).not_to have_content 'Previous'
        expect(page).not_to have_content 'Next'
        expect(page).not_to have_content '1'
        expect(page).not_to have_content '2'
      end
    end

    it 'paginates at most three rewards on one page' do
      reward2 = create(:reward)
      reward3 = create(:reward)
      reward4 = create(:reward)

      visit rewards_path

      # EXACT NUMBER OF PAGINATION LINKS BASED ON NUMBER OF EXISTING REWARDS
      within('div.flickr_pagination') do
        expect(page).to have_content 'Previous'
        expect(page).to have_content 'Next'
        expect(page).to have_content '1'
        expect(page).to have_content '2'
        expect(page).not_to have_content '3'
      end

      # ON THE FIRST PAGE
      expect(page).to have_content reward.title
      expect(page).to have_content reward2.title
      expect(page).to have_content reward3.title
      expect(page).not_to have_content reward4.title

      # ON THE SECOND PAGE
      within('div.flickr_pagination') do
        click_link '2'
      end
      expect(page).not_to have_content reward.title
      expect(page).not_to have_content reward2.title
      expect(page).not_to have_content reward3.title
      expect(page).to have_content reward4.title
    end
  end

  context 'when filtering rewards by categories' do
    let(:category) { create(:category) }
    let!(:reward2) { create(:reward, category: category) }

    it 'shows links to filter by each category' do
      visit root_path
      click_link 'Rewards'

      expect(page).to have_link 'All'
      expect(page).to have_link category.title
    end

    it 'filters rewards by their categories' do
      visit root_path
      click_link 'Rewards'

      expect(page).to have_content reward.title
      expect(page).to have_content reward2.title
      expect(reward.category).to eq nil
      expect(reward2.category).to eq category

      # Testing if filter by category works
      click_link category.title
      expect(page).to have_content reward2.title
      expect(page).not_to have_content reward.title

      # Testing if link to all rewards works
      click_link 'All'
      expect(page).to have_content reward.title
      expect(page).to have_content reward2.title
    end

    it 'shows all rewards when params[:category] have invalid value' do
      visit rewards_path(category: 'invalid')

      expect(page).to have_content reward.title
      expect(page).to have_content reward2.title
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

    it 'does not show a reward when it is not available for purchase' do
      reward_not_for_sale = create(:reward)
      visit "/rewards/#{reward_not_for_sale.id}"

      expect(page).to have_content 'Reward is not available now.'
    end
  end
end
