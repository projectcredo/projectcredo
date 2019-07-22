class PostsController < ApplicationController
  after_action :verify_authorized, except: :load_open_graph

  def create
    param! :list_id, Integer, required: true
    list = List.find(params[:list_id])

    post = list.posts.new(params.require(:post).permit(:content).merge({user: current_user}))
    authorize post
    post.save!

    if params[:article].present?
      article = post.articles.create!(params.require(:article).permit(:title, :url, :cover))
      article.papers << Paper.where(id: params[:article][:papers])
    end

    respond_to do |format|
      format.json {render 'jbuilders/_post', {locals: {post: post}}}
    end
  end

  def update
    post = Post.find(params[:id])
    authorize post

    post.update!(params.require(:post).permit(:content))

    respond_to do |format|
      format.json {render 'jbuilders/_post', {locals: {post: post}}}
    end
  end

  def destroy
    post = Post.find(params[:id])
    authorize post

    post.destroy!

    respond_to do |format|
      format.json { render json: { message: 'Post was deleted' }}
    end
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
