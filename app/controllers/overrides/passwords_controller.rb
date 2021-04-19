module Overrides
  class PasswordsController < DeviseTokenAuth::PasswordsController
    def edit
      @resource = resource_class.with_reset_password_token(resource_params[:reset_password_token])

      if @resource && @resource.reset_password_period_valid?
        token = @resource.create_token
        @resource.save
        sign_in(:user, @resource, store: false, bypass: false)

        redirect_headers = build_redirect_headers(token.token, token.client)
        redirect_headers.each { |key, val| response.headers[key.to_s] = val.to_s if val }
        response.headers['expiry'] = token.expiry
        response.headers['uid'] = @resource.email
        response.headers['token-type'] = 'Bearer'

        render 'jbuilders/_user.json.jbuilder', {locals: {user: @resource}}
      else
        render :nothing => true, :status => :bad_request
      end
    end
  end
end
