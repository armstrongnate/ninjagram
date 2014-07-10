class PostsController < ApplicationController
  before_filter :load_posts
  respond_to :html

  def index
  end

  def create
    @post = Post.new(safe_params)
    @post.save
    respond_with @post, location: posts_url, action: :index
  end


  private

  def load_posts
    @posts = Post.all
  end

  def safe_params
    params.require(:post).permit(:attachment)
  end
end
