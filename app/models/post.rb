class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments, as: :commentable, dependent: :destroy # Comments on the user's profile

  validates :content, presence: true, unless: -> { image.attached? }
  validate :content_or_image_present

  private

  def content_or_image_present
    unless content.present? || image.attached?
      errors.add(:base, "Post must have either content or an image.")
    end
  end
end
