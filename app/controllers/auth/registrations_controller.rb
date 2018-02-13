class Auth::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy, :remove_attachment]

  def remove_attachment
    unless resource.has_attribute?(params[:type]) and resource.public_send(params[:type]).respond_to?(:destroy)
      redirect_to request.referer || root_path, error: 'Invalid attachment type'
      return
    end

    resource.public_send(params[:type]).destroy
    resource.save
    redirect_back notice: 'Attachment was deleted', fallback_location: root_path
  end
end
