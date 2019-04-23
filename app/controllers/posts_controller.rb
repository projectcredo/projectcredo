class PostsController < ApplicationController
  require 'link_thumbnailer'

  def create
    param! :list_id, Integer, required: true

    list = List.find(params[:list_id])

    unless list.accepts_public_contributions? || current_user.can_edit?(list)
      return redirect_back(fallback_location: list_path, alert: 'You must be a contributor to make changes to this list.')
    end

    post = list.posts.create!(params.require(:post).permit(:content).merge({user: current_user}))

    if params[:article].present?
      article = post.articles.create!(params.require(:article).permit(:title, :url, :cover))
    end

    respond_to do |format|
      format.json {render 'jbuilders/_post', {locals: {post: post}}}
    end
  end

  def update
  end

  def destroy
  end

  def load_open_graph
    url = params.require(:url)
    object = LinkThumbnailer.generate(url)

    puts object.inspect

    render json: object
  end

end
