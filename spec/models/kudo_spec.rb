require 'rails_helper'

RSpec.describe Kudo, type: :model do
  it 'has a valid factory' do
    expect(build(:kudo)).to be_valid
  end
end
