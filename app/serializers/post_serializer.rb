class PostSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :image_url,:author

  def image_url
    object.image.attached? ? Rails.application.routes.url_helpers.url_for(object.image) : nil
  end 

  def author
    {
      id: object.user.id,
      name: "#{object.user.first_name} #{object.user.last_name}"
    }
  end
end

