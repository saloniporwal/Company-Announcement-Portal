class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :commentable, polymorphic: true
  validates :content, presence: true

  validate :max_nesting_depth, on: :create # Validation for nesting up to four levels, applied on create

  def max_nesting_depth
    if parent.present?

      if parent.nested_depth >= 4
        errors.add(:parent_id, 'You cannot reply more than 4 times. Please start a new thread.')
      end
    else
      puts "No parent found for this comment"
    end
  end

  def nested_depth
    parent.present? ? parent.nested_depth + 1 : 0
  end
end
