class Api::CommentsController < Api::ApplicationController
  include ActivitiesHelper
  include NotificationsHelper
  include CommentsHelper

  before_action :ensure_current_user
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_api_user
    respond_to do |format|
      if @comment.commentable_type == 'List'
        create_activity_and_notifications(users: [@comment.commentable.user], actable: @comment.commentable, activity_type: 'commented', addable: @comment)
      end
      format.json {render :json => get_json_tree([@comment])[0] }
    end
  end

  def update
    return forbidden() if @comment.user_id != current_api_user.id

    @comment.update(comment_params.permit(:content))
    respond_to do |format|
      format.json {render :json => get_json_tree([@comment])[0] }
    end
  end

  def destroy
    return forbidden() if @comment.user_id != current_api_user.id

    @comment.destroy!
    respond_to do |format|
      format.json {render :json => {}, :status => :no_content}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      parameters = params.require(:comment).permit(:content, :parent_id, :commentable_type, :commentable_id, :list_id)
      valid_type = %w{List Reference Paper}.include? parameters[:commentable_type]
      if !valid_type
        logger.debug "Comment with invalid parent type by #{current_user.username} with params: #{parameters.inspect}"
        parameters[:commentable_type] = nil
      end
      parameters
    end

    def get_commentable_root_list commentable, comment
      return commentable if commentable.is_a?(List)
      return commentable.list if commentable.is_a?(Reference)
      return comment.list if commentable.is_a?(Paper)
    end
end
