class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :author
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id'

  def author
    object.user.first_name + ' ' + object.user.last_name
  end
end
