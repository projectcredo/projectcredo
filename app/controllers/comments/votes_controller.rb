class Comments::VotesController < ApplicationController
  before_action :ensure_current_user
  before_action :set_comment

  def create
    current_user.likes @comment
    @comment.order_siblings
    respond_to do |format|
      format.html { redirect_to :back, notice: 'You like it!' }
      format.js { render 'votes/toggle_like.js.erb', locals: {votable: @comment} }
    end
  end

  def destroy
    current_user.unlike @comment
    @comment.order_siblings
    respond_to do |format|
      format.html { redirect_to :back, notice: 'You unlike it!' }
      format.js { render 'votes/toggle_like.js.erb', locals: {votable: @comment} }
    end
  end

  private
    def votable_params
      params.permit(:id)
    end

    def set_comment
      @comment = Comment.find(votable_params[:id])
    end
end
