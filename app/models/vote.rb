class Vote < ActiveRecord::Base
  belongs_to :option
  belongs_to :user
end
