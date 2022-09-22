require 'rails_helper'
require 'factory_bot_rails'

RSpec.describe 'Listing and deleting kudos by admin', type: :system do
  let(:admin_user) { create(:admin_user) }
  let!(:kudo) { create(:kudo) }

  before do
    driven_by(:rack_test)
    sign_in admin_user
  end

  context 'when list all kudos' do
    it 'enables to list' do
      visit '/admin/pages/dashboard'
      click_link 'Manage Kudos'

      expect(page).to have_content kudo.title
      expect(page).to have_content kudo.content
      expect(page).to have_content kudo.giver.full_name
      expect(page).to have_content kudo.receiver.full_name
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
      expect { click_link 'Destroy' }.to change(Kudo, :count).by(-1)
      expect(page).to have_content 'Kudo was successfully destroyed.'
    end
  end
end
