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

    return "Anonymous"
  end

  def self.search(param)
    param.strip!
    param.downcase!
    to_send_back = (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq

    return nil unless to_send_back

    return to_send_back
  end

  def self.first_name_matches(param)
    return matches('first_name', param)
  end

  def self.last_name_matches(param)
    return matches('last_name', param)
  end

  def self.email_matches(param)
    return matches('email', param)
  end

  def self.matches(field_name, param)
    return User.where("#{field_name} like?", "%#{param}%")
  end

  def except_current_user(users)
    return users.reject { |user| user.id == self.id }
  end

  def not_friend_with?(friend_id)
    return friendships.where(friend_id: friend_id).count < 1
  end

  def strangers(users)
    users = except_current_user(users)

    return users.select{ |user| user.not_friend_with?(self.id) && self.not_friend_with?(user.id) }
  end

end
