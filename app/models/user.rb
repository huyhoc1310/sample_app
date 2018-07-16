class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true,
            length: {maximum: Settings.model.user.name.max}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
            length: {maximum: Settings.model.user.email.max},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true,
            length: {minimum: Settings.model.user.password.min}

  private

  def downcase_email
    email.downcase!
  end
end
