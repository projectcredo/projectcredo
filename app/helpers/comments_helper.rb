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
end
