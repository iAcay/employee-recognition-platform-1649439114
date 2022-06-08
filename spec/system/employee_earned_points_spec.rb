require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Earned points', type: :system do
  let!(:giver) { create(:employee) }
  let!(:receiver) { create(:employee) }
  let!(:company_value) { create(:company_value) }
  let!(:kudo) { build(:kudo, giver: giver, receiver: receiver, company_value: company_value) }
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

  context 'when creating, updating and deleting kudo' do
    # Create first kudo
    before do
      sign_in giver
      visit 'kudos/new'
      fill_in 'Title', with: kudo.title
      fill_in 'Content', with: kudo.content
      select company_value.title, from: 'Company value'
      click_button 'Create Kudo'
    end

    it 'increases the number of earned points after creating a kudo' do
      receiver.reload
      expect(receiver.earned_points).to eq 1

      # Create second kudo
      visit 'kudos/new'
      fill_in 'Title', with: kudo.title
      fill_in 'Content', with: kudo.content
      select company_value.title, from: 'Company value'
      click_button 'Create Kudo'

      receiver.reload
      expect(receiver.earned_points).to eq 2
    end

    it 'changes the number of earned points after changing kudo receiver' do
      new_receiver = create(:employee)
      previous_receiver = receiver

      new_receiver.reload
      previous_receiver.reload
      expect(new_receiver.earned_points).to eq 0
      expect(previous_receiver.earned_points).to eq 1

      # Change kudo receiver
      visit root_path
      click_link 'Edit'
      select new_receiver.email, from: 'Receiver'
      click_button 'Update Kudo'

      new_receiver.reload
      previous_receiver.reload
      expect(new_receiver.earned_points).to eq 1
      expect(previous_receiver.earned_points).to eq 0
    end

    it 'decreases the number of earned points after deleting kudo' do
      receiver.reload
      expect(receiver.earned_points).to eq 1

      # Delete kudo
      visit root_path
      click_link 'Destroy'

      receiver.reload
      expect(receiver.earned_points).to eq 0
    end
  end
end
