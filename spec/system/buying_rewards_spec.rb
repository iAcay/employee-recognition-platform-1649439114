require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Buying rewards', type: :system do
  let!(:employee) { create(:employee, earned_points: 2) }

  before do
    driven_by(:rack_test)
    sign_in employee
    visit root_path
  end

  context 'when buying a reward with online delivery method' do
    it 'displays the number of earned points' do
      expect(page).to have_content employee.earned_points
    end

    it 'decreases number of earned points after buying a reward' do
      reward = create(:reward)
      create(:online_code, reward: reward)

      click_link 'Rewards'
      click_link 'Buy'
      expect(page).to have_content 'Order details:'
      expect { click_button 'Buy' }.to change { employee.reload.earned_points }.by(-reward.price)
      expect(page).to have_content "Reward: #{reward.title} was successfully bought. Congratulations!"
      expect(employee.rewards).to include reward
    end

    it "rejects an attempt to buy a reward if it's not enough points" do
      reward = create(:reward, price: 3)
      create(:online_code, reward: reward)

      click_link 'Rewards'
      click_link 'Buy'

      expect(page).to have_content 'This reward is too expensive for you. ' \
                                   "You need #{reward.price - employee.earned_points} points more."
      expect(employee.rewards).not_to include reward
    end

    it 'rejects an attempt to buy a reward when it is not available' do
      reward = create(:reward)
      visit "/rewards/orders/new?reward=#{reward.id}"
      expect { click_button 'Buy' }.not_to change { employee.rewards.count }
      expect(page).to have_content 'Reward is not available now.'
    end
  end

  context 'when buying a reward with post delivery method' do
    it 'decreases number of earned points after buying a reward' do
      reward = create(:reward, delivery_method: 'post')

      click_link 'Rewards'
      click_link 'Buy'
      expect(page).to have_content 'Order details:'

      fill_in 'Street', with: '221B Baker Street'
      fill_in 'Postcode', with: 'NW1 6XE'
      fill_in 'City', with: 'London'
      expect { click_button 'Buy' }.to change { employee.reload.earned_points }.by(-reward.price)
      expect(page).to have_content "Reward: #{reward.title} was successfully bought. Congratulations!"
      expect(employee.rewards).to include reward
    end
  end
end
