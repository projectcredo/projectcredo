class Auth::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy, :remove_attachment]

  def remove_attachment
    redirect_to request.referer, error: 'Invalid attachment type' unless resource.has_attribute? params[:type]

    resource.public_send(params[:type]).destroy
    resource.save
    redirect_back notice: 'Attachment was deleted'
  end
end
