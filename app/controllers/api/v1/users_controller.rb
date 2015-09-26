class Api::V1::UsersController < Api::ApiController

  before_action :authenticate
  before_action :set_user

  def show
    render json: @user
  end

  def get_follower_count
    followers = Follow.where(target_id: @user.id)
    render json: followers
  end

  def get_following_count
    follows = Follow.where(follower_id: @user.id)
    render json: follows
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
