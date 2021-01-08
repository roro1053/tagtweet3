class PostsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    @posts = Post.includes(:user).order('created_at DESC')
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    tag_list = params[:post][:tag_ids].split(',')
    if @post.save
      @post.save_tags(tag_list)
      flash[:success] = '投稿しました!'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def show

  end

  #def edit
  #end

  #def update
  #end

private

  def post_params
    params.require(:post).permit(:content).merge(user_id: current_user.id)
  end

  def set_post
    @post = Post.find(params[:id])
  end

end
