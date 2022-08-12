class RewardsImportService
  def initialize(data)
    @data = data
  end

  def self.import(file)
    ActiveRecord::Base.transaction do
      CSV.foreach(file.path, headers: true) do |row|
        reward = Reward.find_or_initialize_by(title: row['Title'])
        reward.description = row['Description']
        reward.price = row['Price']
        reward.category = Category.find_or_create_by!(title: row['Category'])
        reward.save!
      end
    end
  end
end
