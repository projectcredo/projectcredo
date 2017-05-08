class CommentsController < ApplicationController
  include ActivitiesHelper
  include NotificationsHelper

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
        format.json {render :json => @comment }
        format.html { redirect_to :back, notice: 'Comment was successfully created.' }
        format.js do
          commentable = @comment.root.commentable
          is_top_level = !!@comment.commentable
          commentable.touch

          if is_top_level
            render('commentables/comments/create.js.erb', locals: {commentable: commentable})
          else
            render('comments/create.js.erb', locals: {commentable: commentable})
          end
        end
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
      flash[:alert] = "You do not have permission to edit this comment"
      return redirect_back(fallback_location: user_list_path(list.owner, list))
    end

    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to :back, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
        format.js { render 'update.js.erb', locals: {commentable: @comment.root.commentable} }
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
    list_for_authorization = get_commentable_root_list commentable

    respond_to do |format|
      if current_user.can_moderate?(list_for_authorization) || @comment.user == current_user
        @comment.destroy
        format.html { redirect_to :back, notice: 'Comment was successfully destroyed.' }
        format.json {render :json => {}, :status => :no_content}
        format.js { render 'destroy.js.erb', locals: {commentable: commentable} }
      else
        flash[:alert] = 'You do not have permission to moderate this list.'
        format.html { redirect_back fallback_location: user_list_path(list_for_authorization.owner, list_for_authorization) }
        format.js { ajax_redirect_to(user_list_path(list_for_authorization.owner, list_for_authorization)) }
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
      parameters = params.require(:comment).permit(:content, :parent_id, :commentable_type, :commentable_id)
      valid_type = %w{List Reference}.include? parameters[:commentable_type]
      if !valid_type
        logger.debug "Comment with invalid parent type by #{current_user.username} with params: #{parameters.inspect}"
        parameters[:commentable_type] = nil
      end
      parameters
    end

    def get_commentable_root_list commentable
      return commentable if commentable.is_a?(List)
      return commentable.list if commentable.is_a?(Reference)
    end

end
