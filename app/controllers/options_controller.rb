class OptionsController < ApplicationController

	def vote
    @option = Option.find(params[:id])
    @option.votes.create
    #redirect_to poll_path(params[:poll_id])
    redirect_to polls_path
  end

end
