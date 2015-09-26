class Api::V1::FollowsController < Api::ApiController

  before_action :authenticate
  before_action :set_user, only: [:get_followers, :get_follows, :create, :destroy]

  def create

    if @follow = Follow.find_by(follower_id: @current_user.id, target_id: @user.id)
      render json: {"errors": [{"status": "409 Conflict", "error": "this relationship already exists"}]}, status: :conflict
    else
      @follow = Follow.new
      @follow[:follower_id] = @current_user.id
      @follow[:target_id] = @user.id

      if @follow.save
        render json: {}, status: :created
      else
        render json: @follow.errors, status: :unprocessable_entity
      end
    end

  end

  def destroy

    if @follow = Follow.find_by(follower_id: @current_user.id, target_id: @user.id)
      @follow.destroy
      head :no_content
    else
      render json: {"errors": [{"status": "404 Conflict", "error": "this relationship does not exist"}]}, status: 404
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
