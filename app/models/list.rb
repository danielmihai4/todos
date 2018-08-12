class List < ApplicationRecord
  has_many :list_users
  has_many :users, through: :list_users
  has_many :items

  belongs_to :user
end
