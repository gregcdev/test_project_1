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

	def key_gen
		google_oauth2_certs_uri = URI("https://www.googleapis.com/oauth2/v1/certs")
		certs = ActiveSupport::JSON.decode(Net::HTTP.get(google_oauth2_certs_uri))

		#token = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjNkZThhNmFiYTM2YWM5YjIzZjRmMDI5MTVjMjdjNWNhNmU0MWEwZTcifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXVkIjoiNDc1OTg2NTQzMTg5LXVkOXBqYnVvNGY0Yzc1M3BqaGNsOGp0MWdlNXNtN3FvLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTA3NTg2MzAwNTQ1MDU4NTkwNjgyIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF6cCI6IjQ3NTk4NjU0MzE4OS00MmZvaW1ydWNjb3RxaGVnMWdkcm5hdDJmOGxvbHE0NC5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImVtYWlsIjoiZ3JlZ2NoYW1iZXJsYWluOTRAZ21haWwuY29tIiwiaWF0IjoxNDQyNzM5MzE1LCJleHAiOjE0NDI3NDI5MTUsIm5hbWUiOiJHcmVnIENoYW1iZXJsYWluIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS8tRnFwdmFQcjk1RjQvQUFBQUFBQUFBQUkvQUFBQUFBQUFDRVEvY2dDRG9lcmtudjQvczk2LWMvcGhvdG8uanBnIiwiZ2l2ZW5fbmFtZSI6IkdyZWciLCJmYW1pbHlfbmFtZSI6IkNoYW1iZXJsYWluIn0.A_7f9N3Gqjbn7L-O1M4WzlDDzaHrGsDL8goc8QoCfaIT54sCJPLEpkJI1AjpOcY4lBKyQAPzkn-j-dM8PP-uP1WP0fRUy_odLeECxZLHSgtHS0Bfb8SzOxcjnpwXY_oaEtb67pyndG1PW90P1Q8S5rpz3z8KNQimeSpQ6mUOLaaQga02B1dyOXBTRLfajLiYkYIOlr50C0hDS7aiN5AC40wdICxfwKUn8TvQXpBQ8gUKxLKb54sxIa3ujTz5c1OJHoNC7iwhB6zYTDQtoUTJnVRfh0u31R4cvrUXnM0lGeRjkmTqKHvLvjNvHlj1jN64gMktYCs78FyOONLUJomgSA"
		token = params[:token]

		header = ActiveSupport::JSON.decode(Base64.decode64(token.split(".")[0]))

		cert = OpenSSL::X509::Certificate.new certs[header["kid"]]
		key = OpenSSL::PKey::RSA.new cert.public_key
		decoded_token = JWT.decode token, key

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
