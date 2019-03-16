class AuthenticationToken < ApplicationRecord
  before_create :generate_token
  before_create :set_expires_at

  belongs_to :user

  def self.valid
    AuthenticationToken.where(expires_at: nil).or(AuthenticationToken.where("expires_at > ?", Time.zone.now))
  end

  private

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end

  def set_expires_at
    self.expires_at = 2.months.from_now
  end
end
