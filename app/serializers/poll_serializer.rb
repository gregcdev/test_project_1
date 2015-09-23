class PollSerializer < ActiveModel::Serializer
  attributes :id, :title, :user, :created_at
  has_many :options

  def user
    temp = {}
    temp[:name] = object.user.name
    temp
  end
end
