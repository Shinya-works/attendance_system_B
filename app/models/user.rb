class User < ApplicationRecord
  before_save { self.email = email.downcase }
  
  validates :name,  presence: true, length: { maximum: 50 }
  # :emailの有効条件の定数を定義
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    # 定義した条件で有効性を検証
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
end
