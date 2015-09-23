class Api::V1::PollsController < Api::ApiController

	before_action :set_poll, only: [:show, :update, :destroy]
	before_action :authenticate

	require 'action_view'
	require 'action_view/helpers'
	include ActionView::Helpers::DateHelper

	def index
		limit = params[:limit] ||= 1
		offset = params[:offset] ||= 0
		@polls = Poll.order('created_at DESC').limit(limit).offset(offset)
		render :json => @polls
	end

	def show
		if @poll
			render :json => @poll
		else
			render :json => {}, :status => 404
		end
	end

	def create
		@poll = Poll.new(poll_params)
		@poll.user_id = @user.id

		if @poll.save
			render :show, status: :created, location: @poll
		else
			render json: @poll.errors, status: :unprocessable_entity
		end
	end

	def update
		if @user != @poll.user
			render :json => {"errors":{"status": "401 Unauthorized", "message": "unauthorized access"}}, :status => :unauthorized
			return false
		end

		if @poll.update(poll_params)
			render :show, status: :ok, location: @poll
		else
			render json: @poll.errors, status: :unprocessable_entity
		end
	end

	def destroy
		if @user == @poll.user
			@poll.destroy
			head :no_content
		else
			head :unauthorized
		end
	end

	private

	def set_poll
		@poll = Poll.find(params[:id])
	end

	def poll_params
    params.require(:poll).permit(:title, options_attributes: [:id, :name, :_destroy])
  end

end
