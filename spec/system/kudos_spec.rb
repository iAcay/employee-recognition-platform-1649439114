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
      expect { click_button 'Create Kudo' }.to change(Kudo, :count).by(1)
      expect(page).to have_content 'Kudo was successfully created.'
    end

    it 'increases the number of earned points after creating a kudo' do
      fill_in 'Title', with: kudo.title
      fill_in 'Content', with: kudo.content
      select company_value.title, from: 'Company value'
      expect { click_button 'Create Kudo' }.to change { receiver.reload.earned_points }.by(1)
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
      edited_kudo = create(:kudo, giver: giver, receiver: receiver, company_value: company_value)

      visit root_path
      click_link 'Edit'
      fill_in 'Title', with: 'ChangedTitle'
      fill_in 'Content', with: 'ChangedContent'
      select new_company_value.title, from: 'Company value'
      click_button 'Update Kudo'

      expect(page).to have_content 'Kudo was successfully updated.'
      edited_kudo.reload
      expect(edited_kudo.title).to eq 'ChangedTitle'
      expect(edited_kudo.content).to eq 'ChangedContent'
      expect(edited_kudo.company_value.title).to eq new_company_value.title
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
      select new_receiver.full_name, from: 'Receiver'
      click_button 'Update Kudo'

      new_receiver.reload
      previous_receiver.reload
      expect(new_receiver.earned_points).to eq 1
      expect(previous_receiver.earned_points).to eq 0
    end

    it 'checks validation when editing kudo without change receiver' do
      create(:kudo, giver: giver, company_value: company_value)
      visit root_path
      click_link 'Edit'

      fill_in 'Title', with: ''
      fill_in 'Content', with: ''
      click_button 'Update Kudo'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Content can't be blank"
    end

    it 'checks validation when editing kudo with change receiver' do
      create(:kudo, giver: giver, company_value: company_value)
      new_receiver = create(:employee)
      visit root_path
      click_link 'Edit'

      fill_in 'Title', with: ''
      fill_in 'Content', with: ''
      select new_receiver.full_name, from: 'Receiver'
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
      visit root_path
      expect { click_button 'Destroy' }.to change(Kudo, :count).by(-1)
      expect(page).to have_content 'Kudo was successfully destroyed.'
    end

    it 'makes destroy button disabled 5 minutes after kudo was sent' do
      visit root_path
      expect(page).to have_button('Destroy', disabled: false)

      travel 6.minutes
      visit root_path

      expect(page).to have_button('Destroy', disabled: true)
    end

    it 'decreases the number of earned points after deleting kudo' do
      receiver.reload
      expect(receiver.earned_points).to eq 1

      # Delete kudo
      visit root_path
      click_button 'Destroy'

      receiver.reload
      expect(receiver.earned_points).to eq 0
    end
  end
end
