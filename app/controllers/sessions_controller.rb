class SessionsController < ApplicationController
  def new
  end
  
  def create
    # ログイン画面から送られてきたsessionキーの中のemailキーでUsersモデル内の情報を取得、小文字化しuserに代入
    user = User.find_by(email: params[:session][:email].downcase)
    # 代入されたuserが有効かどうか、userのpasswordが有効かどうかを判断する
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end
  
  def destroy
    log_out
    flash[:success] = "ログアウトしました。"
    redirect_to root_url
  end
end
