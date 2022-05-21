require 'rails_helper'

RSpec.describe CompanyValue, type: :model do
  describe 'validations' do
    subject { build(:company_value) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
  end
end
