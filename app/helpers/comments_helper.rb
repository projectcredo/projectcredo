module CommentsHelper
  def get_json_tree(comments)
    comments.map do |comment|
      data = comment.as_json
      data[:user] = comment.user.as_json(only: [:username])
      data[:user][:url] = user_lists_path(comment.user.username)
      data[:voted] = user_signed_in? && current_user.voted_for?(comment)
      data[:nested_comments] = get_json_tree(comment.children)
      data
    end
  end
end
