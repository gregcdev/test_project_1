Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], {
    :scope => 'https://www.googleapis.com/auth/youtube.readonly,email,profile',
    :callback_uri => 'http://localhost:3000/auth/google_oauth2/callback'
  }
end
