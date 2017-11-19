class Auth::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy, :remove_avatar]

  def remove_avatar
    resource.avatar.destroy
    resource.save
    redirect_to request.referer || edit_user_registration_path, notice: 'Avatar image was deleted'
  end
end
