class UsersController < ApplicationController
before_action :set_user, only: [:show, :edit, :update, :destroy]  
before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]  
before_action :correct_user, only: [ :edit, :update]  
  
  def index
    # ページネーションを判断できるオブジェクトに置き換える
    @users = User.paginate(page: params[:page], per_page: 20)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'ユーザーを新規登録しました。'
      redirect_to root_url
    else
      render :new
    end
  end
  
  def edit
    @user = User.find(1)
  end
  
  def update
    @user = User.find(1)
    if @user.update_attributes(user_params)
      flash[:success] = 'ユーザー情報を更新しました。'
      redirect_to root_url
    else
      render :edit
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # beforeフィルター
    
    # paramsハッシュからユーザーを取得
    def set_user
      @user = User.find(params[:id])
    end
    
    # ログイン済みのユーザーか確認
    def logged_in_user
      unless logged_in?
        # logged_in_userにはじかれてページ遷移する前にそのページを保存
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # アクセスしたユーザーが現在ログインしているユーザーか確認します
    def correct_user
      redirect_to root_url unless current_user?(@user)
    end
    
end
