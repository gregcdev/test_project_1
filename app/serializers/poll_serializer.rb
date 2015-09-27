class PollSerializer < ActiveModel::Serializer

  attributes :id, :title, :user, :created_at
  has_many :options

  def user
    temp = {}
    temp[:id] = object.user.id
    temp[:name] = object.user.name
    temp[:following?] = object.user.followers.include? scope[:current_user]
    temp[:follower_count] = object.user.followers.count
    temp[:following_count] = object.user.targets.count
    temp
  end

end
