class PostsController < ApplicationController
  require 'link_thumbnailer'

  def load_open_graph
    url = params.require(:url)
    object = LinkThumbnailer.generate(url)

    puts object.inspect

    render json: object
  end
end
