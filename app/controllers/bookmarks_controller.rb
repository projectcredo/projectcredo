class BookmarksController < ApplicationController
  before_action :ensure_current_user
  before_action :set_model

  def allowed_models
    ['Reference', 'Paper']
  end

  def create
    @model.bookmark(user: current_user)
    respond_to do |format|
      format.html { redirect_to :back, notice: 'You added it from bookmarks!' }
      format.json
    end
  end

  def destroy
    @model.remove_bookmark_for(user: current_user)
    respond_to do |format|
      format.html { redirect_to :back, notice: 'You removed it from bookmarks!' }
      format.json
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      className = params[:type].classify.constantize
      @model= className.find(params[:id])
      not_found unless @model.present? && allowed_models.include?(className.to_s)
    end
end
