class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}
  
  def index
    @posts = Post.all.order(created_at: :desc)
  end
  
  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user
  end
  
  def new
    @post = Post.new
  end
  
  def create
    @post = Post.new(content: params[:content], user_id: @current_user.id)
    if @post.save
      # 保存できた場合
      flash[:notice] = "投稿を作成しました"
      if params[:image]
        @post.image_name = "#{@post.id}.jpg"
        image = params[:image]
        File.binwrite("public/posts_images/#{@post.image_name}", image.read)
        @post.save
      end
      redirect_to("/posts/index")
    else
      # 保存できなかった場合
      render("posts/new")
    end
  end
  
  def edit
    @post = Post.find_by(id: params[:id])
  end
  
  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    if params[:image]
      @post.image_name = "#{@post.id}.jpg"
      image = params[:image]
      File.binwrite("public/posts_images/#{@post.image_name}", image.read)
      @post.save
    end
    if @post.save
      # 保存できた場合
      flash[:notice] = "投稿を編集しました"
      redirect_to("/posts/index")
    else
      # 保存できなかった場合
      render("posts/edit")
    end
  end
  
  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end
  
  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      if @current_user.auth_type == 1
      else
        flash[:notice] = "権限がありません"
        redirect_to("/posts/index")
      end
    end
  end
end
