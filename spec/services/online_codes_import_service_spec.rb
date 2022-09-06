require 'rails_helper'

RSpec.describe OnlineCodesImportService do
  context 'when importing online codes from csv file' do
    it 'imports all online codes from csv file' do
      create(:reward, title: 'RewardTest1')
      create(:reward, title: 'RewardTest2')
      params = { file: fixture_file_upload('./spec/fixtures/online_codes/valid_online_codes_import.csv') }
      service = described_class.new(params)

      result = nil
      expect { result = service.import }.to change(OnlineCode, :count).by(2)
      expect(result).to be true
    end

    it 'returns false while csv file does not contain code' do
      create(:reward, title: 'RewardTest1')
      params = { file: fixture_file_upload('./spec/fixtures/online_codes/invalid_no_code_online_codes_import.csv') }
      service = described_class.new(params)

      expect(service.import).to be false
      expect(service.errors.to_s).to include "Code can't be blank"
    end

    it 'returns false while csv file contains reward which does not exist' do
      params = { file: fixture_file_upload('./spec/fixtures/online_codes/invalid_no_reward_online_codes_import.csv') }
      service = described_class.new(params)

      expect(service.import).to be false
      expect(service.errors.to_s).to include "Couldn't find Reward"
    end
  end
end
