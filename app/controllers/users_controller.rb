class UsersController < ApplicationController
before_action :logged_in_user, only: [:show, :edit, :update, :destroy]  
  
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
    
    # ログイン済みのユーザーか確認
    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
end
