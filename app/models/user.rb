class User < ActiveRecord::Base
  has_many :microposts
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_secure_password

  #メールアドレスバリデーション正規表現
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  #モデルのバリデーションを追加
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  #パスワードの存在証明がhas_secure_passwordで動かなかったので、presenceも追加している
  validates :password,  presence: true, length: { minimum: 6 }

  #セッション管理
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
