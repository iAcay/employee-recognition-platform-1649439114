require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Modifying kudos', type: :system do
  let(:admin_user) { create(:admin_user) }
  let!(:kudo) { create(:kudo) }

  before do
    driven_by(:rack_test)
    sign_in admin_user
  end

  context 'when list all kudos' do
    it 'enables to list' do
      
      visit '/admin/pages/dashboard'
      click_link 'Go to Kudos Admin Panel'

      expect(page).to have_content kudo.title
      expect(page).to have_content kudo.content
      expect(page).to have_content kudo.giver.email
      expect(page).to have_content kudo.receiver.email
      expect(page).to have_content 'Destroy'
    end

    it 'unenables to list without log in' do
      sign_out admin_user
      visit '/admin/kudos/'

      expect(page).to have_content 'Admin log in'
    end
  end

  context 'when delete the kudo' do
    it 'enables to delete the kudo' do
      
      visit 'admin/kudos'
      click_link 'Destroy'

      expect(page).to have_content 'Kudo was successfully destroyed.'
      expect(change(Kudo, :count).by(1)).to be_truthy
    end
  end
end
