class FollowSerializer < ActiveModel::Serializer
  attributes :target_id, :follower_id
end
