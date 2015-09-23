class Api::V1::PollsController < Api::ApiController

	before_action :set_poll, only: [:show]

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
		render :json => @poll
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

	def key_gen
		google_oauth2_certs_uri = URI("https://www.googleapis.com/oauth2/v1/certs")
		certs = ActiveSupport::JSON.decode(Net::HTTP.get(google_oauth2_certs_uri))

		token = params[:token]

		header = ActiveSupport::JSON.decode(Base64.decode64(token.split(".")[0]))

		cert = OpenSSL::X509::Certificate.new certs[header["kid"]]
		key = OpenSSL::PKey::RSA.new cert.public_key
		decoded_token = JWT.decode token, key

		#temp = decoded_token[0]["exp"]
		temp = DateTime.now.strftime('%s').to_i
		if temp.to_i < decoded_token[0]["exp"]
			asd = "vaild"
		else
			asd = "expired"
		end

		#render :json => {"exp": decoded_token[0]["exp"], "now": temp, "status": asd}
		render :json => decoded_token
	end

	private

	def set_poll
		@poll = Poll.find(params[:id])
	end

	def poll_params
    params.require(:poll).permit(:title, options_attributes: [:id, :name, :_destroy])
  end

end
