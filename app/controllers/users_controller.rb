class UsersController < ApplicationController
before_action :set_user, only: [:show, :edit, :update, :destroy]  
before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]  
before_action :correct_user, only: [ :edit, :update]  
before_action :set_one_month, only: :show
  
  def index
    # ページネーションを判断できるオブジェクトに置き換える
    @users = User.paginate(page: params[:page], per_page: 20)
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil?).count
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'ユーザーを新規登録しました。'
      redirect_to current_user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'ユーザー情報を更新しました。'
      redirect_to root_url
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email,:department, :password, :password_confirmation)
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
    
    # システム管理権限所有かどうか判定します。
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
