class User < ActiveRecord::Base
  before_save { self.email = email.downcase }

  #モデルのバリデーションを追加
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password

  #パスワードの存在証明がhas_secure_passwordで動かなかったので、presenceも追加している
  validates :password,  presence: true, length: { minimum: 6 }
end
