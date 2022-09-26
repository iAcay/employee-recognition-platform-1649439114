require 'csv'

class OnlineCodesImportService
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
        online_code = OnlineCode.new(code: row['Code'])
        online_code.reward = Reward.find_by!(title: row['Reward'])
        online_code.save!
      end
    end
    true
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound,
         CSV::MalformedCSVError => e
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
