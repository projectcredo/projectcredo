class References::BookmarksController < ApplicationController
  before_action :ensure_current_user

  def create
    reference = Reference.find(params[:id])
    bmark = Bookmark.new(user_id: current_user.id)
    reference.bookmarks << bmark
    respond_to do |format|
      format.html { redirect_to :back, notice: 'You bookmarked it!' }
      format.json
    end
  end

  def destroy
    reference = Reference.find(params[:id])
    reference.bookmarks.where(user_id: current_user.id).first.delete
    respond_to do |format|
      format.html { redirect_to :back, notice: 'You unlike it!' }
      format.json
    end
  end
end
