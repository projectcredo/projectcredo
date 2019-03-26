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
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        if @comment.commentable_type == 'List'
          create_activity_and_notifications(users: @comment.commentable.members, actable: @comment.root.commentable, activity_type: "commented", addable: @comment)
        end
        format.json {render :json => get_json_tree([@comment])[0] }
        format.html { redirect_to :back, notice: 'Comment was successfully created.' }
      else
        format.html { redirect_to :back }
        format.json {render :json => @comment }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    unless @comment.user == current_user
      commentable = @comment.root.commentable
      list = get_commentable_root_list commentable
      flash[:alert] = "You do not have permission to edit this comment"
      return redirect_back(fallback_location: user_list_path(list.owner, list))
    end

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to :back, notice: 'Comment was successfully updated.' }
        format.json {render :json => get_json_tree([@comment])[0] }
      else
        format.html { redirect_to :back, notice: 'Comment was not updated.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    commentable = @comment.root.commentable
    list_for_authorization = get_commentable_root_list commentable, @comment.root

    respond_to do |format|
      if current_user.can_moderate?(list_for_authorization) || @comment.user == current_user
        @comment.destroy
        format.html { redirect_to :back, notice: 'Comment was successfully destroyed.' }
        format.json {render :json => {}, :status => :no_content}
      else
        flash[:alert] = 'You do not have permission to moderate this list.'
        format.html { redirect_back fallback_location: user_list_path(list_for_authorization.owner, list_for_authorization) }
        format.json
      end
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
