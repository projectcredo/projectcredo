class Lists::PinsController < ApplicationController
  before_action :ensure_current_user
  before_action :set_pinned_lists

  def create
    @pinned_lists << List.find_by(slug: list_params[:list_id])

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.json { render nothing: true, status: 204 }
    end
  end

  def destroy
    list = @pinned_lists.find_by(slug: list_params[:list_id])
    @pinned_lists = @pinned_lists.delete(list)

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.json { render nothing: true, status: 204 }
    end
  end

  private
    def set_pinned_lists
      @pinned_lists = current_user.homepage.lists
    end

    def list_params
      params.permit(:list_id)
    end
end
