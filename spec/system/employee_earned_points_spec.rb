require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Earned points', type: :system do
  let!(:employee) { create(:employee, earned_points: 2) }

  before do
    driven_by(:rack_test)
    sign_in employee
    visit root_path
  end

  context 'when working with earned points by receiver' do
    it 'displays the number of earned points' do
      expect(page).to have_content employee.earned_points
    end

    it 'decreases number of earned points after buying a reward' do
      reward = create(:reward)
      expect(employee.earned_points).to eq 2
      click_link 'Rewards'
      click_link 'Buy'
      expect(page).to have_content 'Order details:'
      click_button 'Buy'

      expect(page).to have_content "Reward: #{reward.title} was successfully bought. Congratulations!"
      expect(page).to have_content "Points: #{employee.earned_points - reward.price.to_i}"
      employee.reload
      expect(employee.earned_points).to eq 1
      expect(employee.rewards).to include reward
    end

    it "rejects an attempt to buy a reward if it's not enough points" do
      reward = create(:reward, price: 3)
      expect(employee.earned_points).to eq 2
      click_link 'Rewards'
      click_link 'Buy'

      expect(page).to have_content 'This reward is too expensive for you. ' \
                                   "You need #{reward.price - employee.earned_points} points more."
      employee.reload
      expect(employee.earned_points).to eq 2
      expect(employee.rewards).not_to include reward
    end
  end
end
