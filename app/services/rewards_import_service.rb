require 'csv'

class RewardsImportService
  attr_reader :errors

  def initialize(params)
    @file = params[:file]
    @errors = []
  end

  def call
    check_file_format
    return false if @errors.any?

    ActiveRecord::Base.transaction do
      CSV.foreach(@file.path, headers: true) do |row|
        reward = Reward.find_or_initialize_by(title: row['Title'])
        reward.description = row['Description']
        reward.price = row['Price']
        reward.delivery_method = row['DeliveryMethod']
        reward.category = Category.find_or_create_by!(title: row['Category'])
        reward.save!
      end
    end
    true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid, CSV::MalformedCSVError => e
    @errors << e.message
    false
  end

  private

  def check_file_format
    if @file.nil?
      @errors << 'Please select a file.'
    elsif File.extname(@file) != '.csv'
      @errors << 'File must be a .csv.'
    end
  end
end
