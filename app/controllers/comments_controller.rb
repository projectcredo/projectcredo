class CommentsController < ApplicationController
  include ActivitiesHelper
  include NotificationsHelper
  include CommentsHelper

  before_action :ensure_current_user
  before_action :set_comment, only: [:edit, :update, :destroy]

  # GET /lists/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    authorize :comment
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.commentable_type == 'List'
        create_activity_and_notifications(users: @comment.commentable.members, actable: @comment.commentable, activity_type: 'commented', addable: @comment)
      end
      format.json {render :json => get_json_tree([@comment])[0] }
      format.html { redirect_back fallback_location: root_path, notice: 'Comment was successfully created.' }
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    authorize @comment

    @comment.update(comment_params.permit(:content))
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: 'Comment was successfully updated.' }
      format.json {render :json => get_json_tree([@comment])[0] }
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    authorize @comment

    @comment.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Comment was successfully destroyed.' }
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
