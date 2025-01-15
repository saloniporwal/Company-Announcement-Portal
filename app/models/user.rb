class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy # One user has many posts
  has_many :comments, dependent: :destroy
  validates :first_name, :last_name, :dob, :address, :mobile_number, :gender, presence: true
end
