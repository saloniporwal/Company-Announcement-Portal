class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :dob, :address, :mobile_number, :gender, :email, :message

  def attributes(*args)
    if @instance_options[:current_user_id] != object.id
      hash = super(*args)
      hash.slice!(:id, :first_name, :last_name, :gender, :message) # Only allow the necessary fields for other users
      hash
    else
      super
    end
  end

  def message
    if object.id == @instance_options[:current_user_id]
      "Thanks for being with us!"
    else
      "This is another user's profile."
    end
  end
end
