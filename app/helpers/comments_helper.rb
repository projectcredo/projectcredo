module CommentsHelper
  def comments_tree_for(comments, list_for_authorization)
    comments.map do |comment, nested_comments|
      render 'comments/comment', comment: comment, list_for_authorization: list_for_authorization do
        content_tag(
          :div,
          comments_tree_for(nested_comments, list_for_authorization),
          class: "comments",
          'data-commentable-id' => comment.id
        )
      end
    end.join.html_safe
  end

  def get_json_tree(comments)
    comments.map do |comment|
      data = comment.as_json
      data[:user] = comment.user.as_json(only: [:username])
      data[:user][:url] = user_lists_path(comment.user.username)
      data[:nested_comments] = get_json_tree(comment.children)
      data
    end
  end
end
