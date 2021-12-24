class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  
  validates :name,  presence: true, length: { maximum: 50 }
  # :emailの有効条件の定数を定義
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    # 定義した条件で有効性を検証
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  # :passwordのハッシュ化と:password_confirmation使用可、authenticateメソッド使用可
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  
  # 渡された文字列のハッシュ値を返します
  def User.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine.MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string,cost: cost)
  end
  
  # ランダムなトークンを返します
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続為ハッシュ化したトークンをデータベースに記憶
  def remember
    # rememberメソッドを呼び出した自身のremember_token属性にUser.new_tokenメソッドで生成したランダムなトークンを代入
    self.remember_token = User.new_token
    # update_attributeは1つの属性のみを更新・保存するメソッド、つまり:remember_digest属性の値をremember_tokenを引数として渡したUser.digestメソッドの戻り値に更新保存する
    update_attribute(:remember_digest, User.digest(remember_token))
    # 今回はユーザーのパスワードなどにアクセス出来ないため、update_attributeを用いてバリデーションを素通りさせる必要がある
  end
  # トークンがダイジェストと一致すればtrueを返します。has_secure_passwordのauthenticateの役割を持つようなメソッドのトークン版
  def authenticated?(remember_user)
    # ダイジェストが存在しない場合はfalseを返して終了します。return falseでエラーを防ぐ
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄します。
  def forget
    # :remember_digestをnilに更新保存
    update_attribute(:remember_digest, nil)
  end
  
end
