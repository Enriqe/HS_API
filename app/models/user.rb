class User < ActiveRecord::Base
  has_secure_password
  validates :email, presence: true, uniqueness: { :case_sensitive => false },
                                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  has_many :links, inverse_of: :user

  validates :auth_token, uniqueness: true

  before_validation :generate_authentication_token!

  def generate_authentication_token!
    begin
      self.auth_token = SecureRandom.base64(64)
    end while self.class.exists?(auth_token: auth_token)
  end
end
