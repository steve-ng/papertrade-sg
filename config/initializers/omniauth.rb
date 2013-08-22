OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '149418761930204', '54132b2160b8e685b0a3c548f901b3a8',
  :scope => 'email,user_birthday,read_stream', :display => 'popup'
end

# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_SECRET']
# end