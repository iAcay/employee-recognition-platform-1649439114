require 'rails_helper'

RSpec.describe OnlineCodesImportService do
  context 'when importing online codes from csv file' do
    it 'imports all online codes from csv file' do
      create(:reward, title: 'RewardTest1')
      create(:reward, title: 'RewardTest2')
      params = { file: fixture_file_upload('./spec/fixtures/online_codes/valid_online_codes_import.csv') }
      import_online_codes = described_class.new(params)

      expect(OnlineCode.count).to eq 0
      expect(import_online_codes.import).to be true
      expect(OnlineCode.count).to eq 2
    end

    it 'returns false while csv file does not contain code' do
      create(:reward, title: 'RewardTest1')
      params = { file: fixture_file_upload('./spec/fixtures/online_codes/invalid_no_code_online_codes_import.csv') }
      import_online_codes = described_class.new(params)

      expect(import_online_codes.import).to be false
      expect(import_online_codes.errors.to_s).to include "Code can't be blank"
    end

    it 'returns false while csv file contains reward which does not exist' do
      params = { file: fixture_file_upload('./spec/fixtures/online_codes/invalid_no_reward_online_codes_import.csv') }
      import_online_codes = described_class.new(params)

      expect(import_online_codes.import).to be false
      expect(import_online_codes.errors.to_s).to include "Couldn't find Reward"
    end
  end
end
