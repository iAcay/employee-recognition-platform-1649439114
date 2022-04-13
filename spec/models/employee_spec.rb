require 'rails_helper'

RSpec.describe Employee, type: :model do
  it 'has a valid factory' do
    expect(build(:employee)).to be_valid
  end
end
