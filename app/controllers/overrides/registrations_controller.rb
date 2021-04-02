module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    def render_create_success
      render 'jbuilders/_user.json.jbuilder', {locals: {user: @resource}}
    end
  end
end
