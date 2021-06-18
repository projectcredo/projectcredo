class Api::PostsController < Api::ApplicationController
  before_action :ensure_current_user

  def create
    param! :list_id, Integer, required: true
    list = List.find(params[:list_id])
    return forbidden() if (list.user_id != current_api_user.id)

    post = list.posts.new(params.require(:post).permit(:content).merge({user: current_api_user}))
    post.save!

    if params[:article].present?
      article = post.articles.create!(params.require(:article).permit(:title, :url, :cover))
      article.papers << Paper.where(id: params[:article][:papers])
    end

    render 'jbuilders/_post', {locals: {post: post}}
  end

  def update
    post = Post.find(params[:id])
    return forbidden() if (post.user_id != current_api_user.id)

    post.update!(params.require(:post).permit(:content))

    render 'jbuilders/_post', {locals: {post: post}}
  end

  def destroy
    post = Post.find(params[:id])
    return forbidden() if (post.user_id != current_api_user.id)

    post.destroy!

    render json: { message: 'Post was deleted' }
  end

  def load_open_graph
    url = params.require(:url)

    begin
      object = Papers::Scraper.new.scrap_url(url)

      return render json: object
    rescue PapersScraperError => e
      return render status: 400, body: e.message
    end
  end

end
