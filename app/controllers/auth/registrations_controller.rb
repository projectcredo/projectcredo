class Auth::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy, :remove_avatar]

  def remove_attachment
    redirect_to request.referer, error: 'Invalid attachment type' unless resource.has_attribute? params[:type]

    resource[params[:type]].destroy
    resource.save
    redirect_to request.referer || edit_user_registration_path, notice: 'Attachment was deleted'
  end
end
