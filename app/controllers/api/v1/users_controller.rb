class Api::V1::UsersController < Api::ApiController

  before_action :authenticate
  before_action :set_user, only: [:show]

  def show
    render json: @user
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

end
