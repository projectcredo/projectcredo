module Overrides
  class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    include Devise::Controllers::Rememberable

    def omniauth_success
      puts 'omniauth_success'
      if params[:provider] == 'facebook'
        facebook
      end
    end

    protected

    def facebook

      user, password, user_created = User.from_omniauth(request.env['omniauth.auth'])

      if user.persisted?
        ApplicationMailer.omniauth_registration(user, password, 'Facebook').deliver if user_created
      end
    end
  end
end
