class PinsController < ApplicationController
  before_action :ensure_current_user
  before_action :set_pinned_lists

  def create
    @pinned_lists << List.find_by(slug: list_params[:list_id])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    list = @pinned_lists.find_by(slug: list_params[:list_id])
    @pinned_lists = @pinned_lists.delete(list)
    redirect_back(fallback_location: root_path)
  end

  private
    def set_pinned_lists
      @pinned_lists = current_user.homepage.lists
    end

    def list_params
      params.permit(:list_id)
    end
end
