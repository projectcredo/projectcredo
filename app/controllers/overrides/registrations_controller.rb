module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController

    def create
      success = verify_recaptcha(action: 'login', minimum_score: 0.5, secret_key: ENV['RECAPTCHA_SECRET_KEY_V3'])
      if not success
        return render plain: 'Invalid captcha', :status => :bad_request
      end
      super
    end

    def render_create_success
      render 'jbuilders/_user.json.jbuilder', {locals: {user: @resource}}
    end

    def render_update_success
      render 'jbuilders/_user.json.jbuilder', {locals: {user: @resource}}
    end
  end
end
