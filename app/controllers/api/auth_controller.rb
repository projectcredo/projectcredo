class Api::AuthController < Api::ApplicationController
  before_action :ensure_current_user, only: [:me]

  def facebook
    auth = Auth::Facebook.new(params.require(:accessToken))
    password = Devise.friendly_token[0,20]
    user = User.where(email: auth.user_data['email']).first_or_create do |user|
      user.password = password
      user.username = auth.user_data['name'].parameterize.underscore
      if ! auth.user_data['picture'].empty? then user.avatar = open(auth.user_data['picture']['url']) end
      user.skip_confirmation!
    end

    auth_headers = user.create_new_auth_token
    auth_headers.each { |key, value| response.headers[key] = value }

    render 'jbuilders/_user.json.jbuilder', {locals: {user: user}}
  end

  def me
    render 'jbuilders/_user.json.jbuilder', {locals: {user: @current_user}}
  end
end
