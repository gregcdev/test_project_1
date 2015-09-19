class Option < ActiveRecord::Base
  belongs_to :poll
  has_many :votes, dependent: :destroy
end
