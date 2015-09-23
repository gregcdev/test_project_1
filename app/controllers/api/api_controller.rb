class Api::ApiController < ActionController::Base

  def google_oauth2

    #Retrieves the token string from the URL and parses the header
    #token = params[:token]
    token = request.headers['oauth2-token']
    split = token.split(".")
		header = ActiveSupport::JSON.decode(Base64.decode64(split[0]))
    body = ActiveSupport::JSON.decode(Base64.decode64(split[1]))

    if body["exp"] < DateTime.now.strftime('%s').to_i
      return render :json => {"status": "401 Unauthorized", "error": "expired token"}, status: :unauthorized
    end

    #Checks if the google certs are cached and retrieves them if they are not
    if certs = Rails.cache.read("certs")
      temp = "exists"
    else
      temp = "doesnt exist"
      google_oauth2_certs_uri = URI("https://www.googleapis.com/oauth2/v1/certs")
		  certs = ActiveSupport::JSON.decode(Net::HTTP.get(google_oauth2_certs_uri))
      Rails.cache.write("certs", certs)
    end
    #creates a new certificate for the token key id and created the public_key from the certificate
		cert = OpenSSL::X509::Certificate.new certs[header["kid"]]
		key = OpenSSL::PKey::RSA.new cert.public_key
    #verifies that the token has been sent from google and decodes it
		decoded_token = JWT.decode token, key

    auth = {'provider'=> "google_oauth2", 'name'=> decoded_token[0]["name"], 'uid'=> decoded_token[0]["sub"]}

    #Signs the user in with the info from the token or creates the user if they do not exist
    u = User.sign_in_from_api(auth)

    render :json => {"name": u.name, "api_key": u.api_key, "status": temp}
  end

  private

  def authenticate
    api_key = request.headers['X-Api-Key']
    @user = User.where(api_key: api_key).first if api_key

    unless @user
      head status: :unauthorized
      return false
    end
  end

  def current_user

  end

end
