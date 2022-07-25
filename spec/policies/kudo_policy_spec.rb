require 'rails_helper'

describe KudoPolicy do
  subject(:kudo_policy) { described_class }

  let!(:employee) { create(:employee) }
  let!(:kudo) { create(:kudo, giver: employee) }

  permissions :update?, :destroy? do
    it 'grants access to update and destroy kudo for 5 minutes after it was created' do
      expect(kudo_policy).to permit(employee, kudo)
    end

    it 'denies access to update and destroy kudo 5 minutes after it was created' do
      travel_to kudo.created_at.advance(minutes: 6)
      expect(kudo_policy).not_to permit(employee, kudo)
    end
  end
end
