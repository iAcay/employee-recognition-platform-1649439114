class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :number_of_available_kudos, numericality: { less_than_or_equal_to: 10, greater_than_or_equal_to: 0 }
end
