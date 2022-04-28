require 'rails_helper'

RSpec.describe CompanyValue, type: :model do
  it 'has a valid factory' do
    expect(build(:company_value)).to be_valid
  end

  context 'when title is nil' do
    it { is_expected.to validate_presence_of(:title) }
  end

  context 'when title is not unique' do
    subject { build(:company_value, title: 'Title') }

    it { is_expected.to validate_uniqueness_of(:title) }
  end
end
