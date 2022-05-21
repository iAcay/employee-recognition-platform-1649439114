class Employee < ApplicationRecord
  has_many :given_kudos, class_name: 'Kudo', foreign_key: 'giver_id', inverse_of: :giver, dependent: :destroy
  has_many :received_kudos, class_name: 'Kudo', foreign_key: 'receiver_id', inverse_of: :receiver, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :number_of_available_kudos, numericality: { less_than_or_equal_to: 10, greater_than_or_equal_to: 0 }
end
