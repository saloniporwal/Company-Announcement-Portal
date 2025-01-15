class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy # One user has many posts
  has_many :comments, dependent: :destroy
  validates :first_name, :last_name, :dob, :address, :mobile_number, :gender, presence: true 
  has_many :comments, as: :commentable, dependent: :destroy # Comments on the user's profile
  has_many :written_comments, class_name: 'Comment', foreign_key: 'user_id'

end
