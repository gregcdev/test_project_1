class Api::V1::PollsController < ApplicationController

	before_action :set_poll, only: [:show]

	def index
		limit = params[:limit] ||= 1
		offset = params[:offset] ||= 0
		@polls = Poll.order('created_at DESC').limit(limit).offset(offset)
	end

	def show
		@poll.created_at = time_ago_in_words(@poll.created_at)
	end

	def create
		@poll = Poll.new(poll_params)

		if @poll.save
			render :show, status: :created, location: @poll
		else
			render json: @poll.errors, status: :unprocessable_entity
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