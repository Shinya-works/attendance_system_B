class UsersController < ApplicationController
before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]  
before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]  
before_action :correct_user_or_admin_user, only: :show
before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
before_action :set_one_month, only: :show
  
  def index
    # ページネーションを判断できるオブジェクトに置き換える
    @users = User.paginate(page: params[:page], per_page: 20)
    
    @users = @users.where('name LIKE ?',"%#{params[:search]}%") if params[:search].present?
    
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
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
      redirect_to users_url
    else
      flash[:danger] = "#{@user.name}の基本情報の更新に失敗しました。" + @user.errors.full_messages.join("、")
      render :edit_basic_info
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email,:department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
    end
    
    
end
