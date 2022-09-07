require 'csv'

class OnlineCodesImportService
  attr_reader :errors

  def initialize(params)
    @file = params[:file]
    @errors = []
  end

  def import
    if @file.nil?
      @errors << 'file cannot be empty'
      false
    elsif File.extname(@file) != '.csv'
      @errors << 'must be a .csv file'
      false
    else
      ActiveRecord::Base.transaction do
        CSV.foreach(@file.path, headers: true) do |row|
          online_code = OnlineCode.new(code: row['Code'])
          online_code.reward = Reward.find_by!(title: row['Reward'])
          online_code.save!
        end
      end
      true
    end
  rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound => e
    @errors << e.message
    false
  end
end
