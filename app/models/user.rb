class User < ActiveRecord::Base

  before_create do |doc|
    doc.api_key = doc.generate_api_key
  end

  has_many :polls, dependent: :destroy
  has_many :votes, dependent: :destroy

  has_many :followers, :class_name => 'Follow', :foreign_key => 'target_id', dependent: :destroy
  has_many :follows, :class_name => 'Follow', :foreign_key => 'follower_id', dependent: :destroy

  def self.sign_in_from_omniauth(auth)
    find_by(provider: auth['provider'], uid: auth['uid']) || create_user_from_omniauth(auth)
  end

  def self.create_user_from_omniauth(auth)
    create(
      provider: auth['provider'],
      uid: auth['uid'],
      name: auth['info']['name']
    )
  end

  def self.sign_in_from_api(auth)
    find_by(provider: auth['provider'], uid: auth['uid']) || create_user_from_api(auth)
  end

  def self.create_user_from_api(auth)
    create(
      provider: auth['provider'],
      uid: auth['uid'],
      name: auth['name'],
      email: auth['email']
    )
  end

  def generate_api_key
    loop do
      token = SecureRandom.base64.tr('+/=', 'Qrt')
      break token unless User.exists?(api_key: token)
    end
  end

end
