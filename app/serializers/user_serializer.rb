class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :follower_count, :following_count

  def follower_count
    object.followers.count
  end

  def following_count
    object.follows.count
  end
end
