class OptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :votes

  def votes
    object.votes.count
  end
end
