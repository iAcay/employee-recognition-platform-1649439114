require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Working on kudos', type: :system do
  let!(:giver) { create(:employee) }
  let!(:receiver) { create(:employee) }
  let!(:company_value) { create(:company_value) }
  let!(:kudo) { build(:kudo, giver: giver, receiver: receiver, company_value: company_value) }

  before do
    driven_by(:rack_test)
  end

  context 'when creating a kudo' do
    before do
      sign_in giver
      visit root_path
      click_link 'New Kudo'
    end

    it 'enables to create a kudo' do
      fill_in 'Title', with: kudo.title
      fill_in 'Content', with: kudo.content
      select company_value.title, from: 'Company value'
      click_button 'Create Kudo'

      expect(page).to have_content 'Kudo was successfully created.'
      expect(Kudo.count).to eq 1
    end

    it 'increases the number of earned points after creating a kudo' do
      receiver.reload
      expect(receiver.earned_points).to eq 0

      fill_in 'Title', with: kudo.title
      fill_in 'Content', with: kudo.content
      select company_value.title, from: 'Company value'
      click_button 'Create Kudo'

      receiver.reload
      expect(receiver.earned_points).to eq 1
    end

    it 'checks validation' do
      fill_in 'Title', with: ''
      fill_in 'Content', with: ''
      click_button 'Create Kudo'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Content can't be blank"
      expect(page).to have_content 'Company value must exist'
    end
  end

  context 'when editing a kudo' do
    before do
      sign_in giver
      visit root_path
    end

    it 'enables to edit a kudo' do
      new_company_value = create(:company_value, title: 'Company Value test')
      edited_kudo = create(:kudo, giver: giver, company_value: company_value)

      expect(edited_kudo.title).to eq 'Great Worker!'
      expect(edited_kudo.content).to eq 'He did his work three times faster than others.'
      expect(edited_kudo.company_value.title).to eq 'Company Value Title'

      visit root_path
      click_link 'Edit'
      fill_in 'Title', with: 'Super Worker!'
      fill_in 'Content', with: 'He works with really good attitude!'
      select new_company_value.title, from: 'Company value'
      click_button 'Update Kudo'

      edited_kudo.reload
      expect(page).to have_content 'Kudo was successfully updated.'
      expect(edited_kudo.title).to eq 'Super Worker!'
      expect(edited_kudo.content).to eq 'He works with really good attitude!'
      expect(edited_kudo.company_value.title).to eq 'Company Value test'
    end

    it 'changes the number of earned points after changing kudo receiver' do
      click_link 'New Kudo'
      fill_in 'Title', with: kudo.title
      fill_in 'Content', with: kudo.content
      select company_value.title, from: 'Company value'
      click_button 'Create Kudo'

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

    it 'checks validation' do
      create(:kudo, giver: giver, company_value: company_value)
      visit root_path
      click_link 'Edit'

      fill_in 'Title', with: ''
      fill_in 'Content', with: ''
      click_button 'Update Kudo'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Content can't be blank"
    end

    it 'checks authorization' do
      new_kudo = create(:kudo, company_value: company_value)
      visit root_path

      expect(page).to have_content 'Unauthorized'

      visit "kudos/#{new_kudo.id}/edit"

      expect(page).to have_content 'Not authorized to edit this Kudo.'
    end
  end

  context 'when deleting a kudo' do
    before do
      sign_in giver
      visit root_path
      click_link 'New Kudo'
      fill_in 'Title', with: kudo.title
      fill_in 'Content', with: kudo.content
      select company_value.title, from: 'Company value'
      click_button 'Create Kudo'
    end

    it 'enables to delete a kudo within 5 minutes after it was sent' do
      expect(Kudo.count).to eq 1
      visit root_path
      click_link 'Destroy'

      expect(page).to have_content 'Kudo was successfully destroyed.'
      expect(Kudo.count).to eq 0
    end

    it 'disallow to remove a kudo 5 minutes after it was sent' do
      expect(Kudo.count).to eq 1
      visit root_path

      travel 6.minutes

      visit root_path
      click_link 'Destroy'

      expect(page).not_to have_content 'Kudo was successfully destroyed.'
      expect(Kudo.count).to eq 1
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
