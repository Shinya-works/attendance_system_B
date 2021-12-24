module SessionsHelper
    
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def log_out
    # 一時セッションの:user_idキーの情報を削除
    session.delete(:user_id)
    # あわせて@current_userに代入されたidを削除する
    @current_user = nil
  end
  
  # ログインしているユーザーの情報を代入するメソッド
  def current_user
    if session[:user_id]
      # @current_userがあった場合(二回目の処理)current_userメソッドの戻り理に@current_userを入れる||ログインで定義したsession[:user_id]をつかってUser内の情報を取得し@current_userに代入
      @currrnt_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  def logged_in?
    # current_userメソッドを使用しそれがnilであった場合を否定している
    !current_user.nil?
  end
end
