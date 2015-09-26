class Api::V1::VoteController < Api::ApiController

  before_action :authenticate

  def cast_vote

    #Checks that the requested option belongs to the requested poll
    if option = Option.find(params[:option_id].to_i)
      if option.poll_id != params[:poll_id].to_i
        render json: {"errors":{"status": "409 Conflict", "message": "the requested option does not belong to the requested poll"}}, status: :conflict
        return false
      end
    end

    #Checks if the User has voted for this poll
    if vote = Vote.find_by(user_id: @current_user.id, poll_id: params[:poll_id].to_i)

      #Checks if the user has already voted for this option
      if vote.option_id == params[:option_id].to_i
        render json: {"errors":{"status": "403 Forbidden", "message": "cannot vote for an option more than once"}}, status: :forbidden
        return false
      end

      #Updates the vote if a different option for this poll is requested
      if vote.update_attribute(:option_id, params[:option_id].to_i)
  			render json: {}, status: :ok
  		else
  			render json: vote.errors, status: :unprocessable_entity
  		end

    else

      #Creates a new vote if the user has not voted for this poll
      vote = Vote.new
      vote.user_id = @current_user.id
      vote.poll_id = params[:poll_id].to_i
      vote.option_id = params[:option_id].to_i

      if vote.save
  			render json: {}, status: :created
  		else
  			render json: vote.errors, status: :unprocessable_entity
  		end

    end

  end

end
