class Api::RegistrationsController < Api::ApplicationController
  before_action :authenticate_api_user!

  def remove_attachment
    unless @current_user.public_send(params[:type]).respond_to?(:destroy)
      render :nothing => true, :status => :bad_request
      return
    end

    @current_user.public_send(params[:type]).destroy
    @current_user.save
    render 'jbuilders/_user.json.jbuilder', {locals: {user: @current_user}}
  end
end
