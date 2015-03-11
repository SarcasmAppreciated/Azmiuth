Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "GOLr7vhTG0zTBSwDrGrCggGes", "F0gHakPmJvFp8x5zDlNnILN52TAF1AbQmZ2sEYqiT3I0k1m8DF"
# Added to config/initializers/omniauth.rb

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

end