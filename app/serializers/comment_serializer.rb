class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :updated_at,:author
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id'

  def author
    [object.user&.first_name, object.user&.last_name].compact.join(' ')
  end
end
