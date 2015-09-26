class PollSerializer < ActiveModel::Serializer
  attributes :id, :title, :user, :created_at
  has_many :options

  def user
    temp = {}
    temp[:id] = object.user.id
    temp[:name] = object.user.name
    temp
  end

end
