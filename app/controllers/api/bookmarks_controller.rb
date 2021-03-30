class Api::BookmarksController < Api::ApplicationController
  before_action :ensure_current_user
  before_action :set_model, only: [:create, :destroy]

  def allowed_models
    ['Article', 'Paper']
  end

  def show
    @bookmarks = @current_user.bookmarks.paginate(:page => params[:page], :per_page => 30)

    respond_to do |format|
      format.json { render json: @bookmarks }
    end
  end

  def create
    @model.bookmark(user: @current_user)
    respond_to do |format|
      format.json
    end
  end

  def destroy
    @model.remove_bookmark_for(user: @current_user)
    respond_to do |format|
      format.json
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_model
      className = params[:type].classify.constantize
      @model = className.find(params[:id])
      not_found unless @model.present? && allowed_models.include?(className.to_s)
    end
end
