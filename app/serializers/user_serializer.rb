class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :followers, :following

  def followers
    object.followers.count
  end

  def following
    object.follows.count
  end
end
