require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Working on earned points', type: :system do
  let!(:giver) { create(:employee) }
  let!(:receiver) { create(:employee) }
  let!(:company_value) { create(:company_value) }
  let!(:kudo) { build(:kudo, giver: giver, receiver: receiver, company_value: company_value) }

  before do
    driven_by(:rack_test)
  end

  context 'when displaying earned points by receiver' do
    it 'enables to display the number of earned points' do
      sign_in receiver
      visit root_path

      expect(page).to have_content receiver.earned_points
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
