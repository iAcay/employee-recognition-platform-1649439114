require 'csv'

class RewardsImportService
  attr_reader :errors

  def initialize(params)
    @file = params[:file]
    @errors = []
  end

  def call
    if @file.nil?
      @errors << 'file cannot be empty'
      false
    elsif File.extname(@file) != '.csv'
      @errors << 'must be a .csv file'
      false
    else
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
    end
  rescue ActiveRecord::RecordInvalid => e
    @errors << e.message
    false
  end
end
