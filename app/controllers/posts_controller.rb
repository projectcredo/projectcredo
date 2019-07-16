class PostsController < ApplicationController
  include PapersScraperHelper
  require 'link_thumbnailer'

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
      html = fetch(url).body

      scraper = LinkThumbnailer::Scraper.new(html, URI(url))
      object = scraper.call.as_json

      object[:papers] = parse_papers(html, [url]).map {|p| p.slice('id', 'title', 'type', 'url', 'source_id')}

      return render json: object
    rescue OpenURI::HTTPError => e
      puts e.inspect
      return render status: 400, body: 'Could not load the URL'
    end
  end

end
