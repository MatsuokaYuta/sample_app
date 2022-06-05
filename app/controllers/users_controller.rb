class UsersController < ApplicationController
  before_action :authenticate_user, {only: [:index, :show, :edit, :update]}
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
  before_action :ensure_correct_user, {only: [:edit, :update]}
  
  def index
    @users = User.all.order(created_at: :desc)
  end
  
  def show
    @user = User.find_by(id: params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(name: params[:name], email: params[:email], password: params[:password])
    @user.auth_type = 2
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      # redirect_to("/users/#{@user.id}")
      redirect_to("/posts/index")
    else
      render("users/new")
    end
  end
  
  def edit
    @user = User.find_by(id: params[:id])
  end
  
  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end
  
  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    @posts = Post.where(user_id: params[:id])
    @posts.destroy_all
    flash[:notice] = "ユーザー情報を削除しました"
    redirect_to("/users/index")
  end
  
  def login_form
  end
  
  def administrayor_login_form
  end
  
  def login
    @user = User.find_by(name: params[:name], password: params[:password])
    if @user
      if @user.auth_type == 1
        # 管理者なら
        flash[:notice] ="管理者用ログインページからログインしてください"
        redirect_to("/administrayor_login")
      else
        session[:user_id] = @user.id
        flash[:notice] ="ログインしました"
        redirect_to("/posts/index")
      end
    else
      @error_message = "ユーザー名、またはパスワードが間違っています"
      @name = params[:name]
      @password = params[:password]
      render("users/login_form")
    end
  end
  
  # def administrayor_login
  #   @user = User.find_by(name: params[:name], password: params[:password])
  #   if @user.auth_type == 1
  #     # 管理者なら
  #     if @user
  #     session[:user_id] = @user.id
  #     flash[:notice] ="ログインしました"
  #     redirect_to("/users/index")
  #     else
  #       @error_message = "ユーザー名、またはパスワードが間違っています"
  #       @name = params[:name]
  #       @password = params[:password]
  #       render("users/administrayor_login_form")
  #     end
  #   else
  #     # 管理者じゃないなら
  #     flash[:notice] = "そのユーザーは管理者ではありません"
  #     render("users/administrayor_login_form")
  #   end
  # end
  
  def administrayor_login
    @user = User.find_by(name: params[:name], password: params[:password])
    if @user
      if @user.auth_type == 1
        session[:user_id] = @user.id
        flash[:notice] ="ログインしました"
        redirect_to("/users/index")
      else
        flash[:notice] = "そのユーザーは管理者ではありません"
        render("users/administrayor_login_form")
      end
    else
      @error_message = "ユーザー名、またはパスワードが間違っています"
      @name = params[:name]
      @password = params[:password]
      render("users/administrayor_login_form")
    end
  end
  
  def logout
    session[:user_id] = nil
    flash[:notice] ="ログアウトしました"
    redirect_to("/login")
  end
  
  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end
end
