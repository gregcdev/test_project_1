class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :follower_count, :following_count, :followed

  def follower_count
    object.followers.count
  end

  def following_count
    object.follows.count
  end

  def followed
    object.follows.include? scope[:current_user]
  end
end
