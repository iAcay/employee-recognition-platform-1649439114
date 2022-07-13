class Employee < ApplicationRecord
  has_many :given_kudos, class_name: 'Kudo', foreign_key: 'giver', inverse_of: :giver, dependent: :destroy
  has_many :received_kudos, class_name: 'Kudo', foreign_key: 'receiver', inverse_of: :receiver, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :rewards, through: :orders

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :number_of_available_kudos, numericality: { greater_than_or_equal_to: 0 }
  validates :earned_points, numericality: { greater_than_or_equal_to: 0 }
end
