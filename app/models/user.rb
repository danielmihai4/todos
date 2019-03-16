class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :friendships
  has_many :friends, through: :friendships
  has_many :list_users
  has_many :lists, through: :list_users
  has_many :authentication_tokens

  def full_name
    return "#{first_name} #{last_name}".strip if (first_name || last_name)

    "Anonymous"
  end

  def self.search(param)
    param.strip!
    param.downcase!
    to_send_back = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq

    return nil unless to_send_back

    to_send_back
  end

  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.matches(field_name, param)
    User.where("#{field_name} like?", "%#{param}%")
  end

  def except_current_user(users)
    users.reject { |user|  user.id == self.id }
  end

  def not_friend_with?(friend_id)
    friendships.where(friend_id: friend_id).count < 1
  end

end
