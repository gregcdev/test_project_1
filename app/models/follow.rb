class Follow < ActiveRecord::Base

  belongs_to :follower, :class_name => 'User', :foreign_key => 'follower_id'
  belongs_to :target, :class_name => 'User', :foreign_key => 'target_id'

end
