class User < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  has_many :tracks, dependent: :destroy

  validates_presence_of :email, :password_digest, :access_token
  validates_uniqueness_of :email
  validates :email, format: { with: EMAIL_REGEX,
                              message: "is not a valid email" }

  has_secure_password

  before_validation :ensure_access_token

  def ensure_access_token
    if self.access_token.blank?
      self.access_token = User.generate_token
    end
  end

  def self.generate_token
    token = SecureRandom.hex
    while User.exists?(access_token: token)
      token = SecureRandom.hex
    end
    token
  end

  def regenerate_token!
    self.access_token = nil
    self.save
  end

  def soundcloud
    opts = {
      access_token: self.access_token,
      refresh_token: self.refresh_token
    }
    SoundcloudApi.new(opts)
  end
end
