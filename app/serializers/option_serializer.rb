class OptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :vote_count

  def vote_count
    object.votes.count
  end
end
