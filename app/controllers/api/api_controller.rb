class Api::ApiController < ActionController::Base

  def google_oauth2

    #Retrieves the token string from the URL and parses the header
    #token = params[:token]
    token = request.headers['oauth2-token']
    if token == nil
      render json: {"status": "401 Unauthorized", "error": "no oauth2-token header"}, status: :unauthorized
      return false
    end

    split = token.split(".")

    #catchs not Base64 decodable tokens and returns an error
    begin
  		header = ActiveSupport::JSON.decode(Base64.decode64(split[0]))
      body = ActiveSupport::JSON.decode(Base64.decode64(split[1]))
    rescue
      render json: {"status": "401 Unauthorized", "error": "invalid token"}, status: :unauthorized
      return false
    end

    if body["exp"] < DateTime.now.strftime('%s').to_i
      return render :json => {"status": "401 Unauthorized", "error": "expired token"}, status: :unauthorized
    end

    #Checks if the google certs are cached and retrieves them if they are not
    if @certs = Rails.cache.read("certs")
      #Checks if the cached certs are expired
      if @certs[header["kid"]] == nil
        get_certs
      end
    else
      get_certs
    end

    #creates a new certificate for the token key id and created the public_key from the certificate
		cert = OpenSSL::X509::Certificate.new @certs[header["kid"]]
		key = OpenSSL::PKey::RSA.new cert.public_key
    #verifies that the token has been sent from google and decodes it
		decoded_token = JWT.decode token, key

    auth = {
      'provider'=> "google_oauth2",
      'name'=> decoded_token[0]["name"],
      'uid'=> decoded_token[0]["sub"],
      'email'=> decoded_token[0]["email"]
    }

    #Signs the user in with the info from the token or creates the user if they do not exist
    u = User.sign_in_from_api(auth)

    render json: {"id": u.id, "name": u.name, "api_key": u.api_key}
  end

  private

  def authenticate
    api_key = request.headers['X-Api-Key']
    @current_user = User.where(api_key: api_key).first if api_key

    unless @current_user
      head status: :unauthorized
      return false
    end
  end

  def get_certs
    google_oauth2_certs_uri = URI("https://www.googleapis.com/oauth2/v1/certs")
    @certs = ActiveSupport::JSON.decode(Net::HTTP.get(google_oauth2_certs_uri))
    Rails.cache.write("certs", @certs)
  end

end
