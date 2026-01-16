class User < ApplicationRecord
  before_save :format_username
  before_save :email
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie
  has_secure_password

  validates :username, presence: true, format: { with: /\A[A-Z0-9]+\z/i }, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A\S+@\S+\z/ }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 10, allow_blank: true }

  def gravatar_id
    Digest::MD5.hexdigest(email.downcase)
  end

  def format_username
    self.username = username.downcase
  end

  def fomrat_email
    self.email = email.downcase
  end
end
