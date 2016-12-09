class LinksController < ApplicationController
  before_action :ensure_current_user

  def destroy
    link = Link.find(link_params[:id])
    url = link.url
    reference = Reference.find(params[:reference])
    list = reference.list

    respond_to do |format|
      list_path = user_list_path(list.owner, list)
      if current_user.can_moderate?(list)
        link.destroy
        format.html do
            redirect_back(
              fallback_location: list_path,
              notice: "'#{link.url}' has been successfully removed from '#{link.paper.title}'"
            )
        end
        format.js { render('destroy.js.erb', locals: { url: url, reference_id: reference.id }) }
      else
        flash[:alert] = 'You do not have permission to moderate this list.'

        format.html { redirect_back(fallback_location: list_path) }
        format.js { ajax_redirect_to(list_path) }
      end
    end
  end

  private

    def link_params
      params.permit(:id)
    end
end
