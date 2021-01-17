class PostsController < ApplicationController
  before_action :set_post, only: [:show,:edit,:update]

  def index
    @post = Post.new
    @posts = Post.includes(:user).order('created_at DESC')
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    tag_list = params[:post][:tag_ids].split(/[[:blank:]]+/).select(&:present?)
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

  def edit
    @tag_list =@post.tags.pluck(:name).join(" ")
  end

  def update
    tag_list = params[:post][:tag_ids].split(/[[:blank:]]+/).select(&:present?)
    if @post.update_attributes(post_params)
      @post.save_tags(tag_list)
      flash[:success] = '投稿を編集しました‼'
      redirect_to @post
    else
    render 'edit'
    end
  end

private

  def post_params
    params.require(:post).permit(:content).merge(user_id: current_user.id)
  end

  def set_post
    @post = Post.find(params[:id])
  end

end
