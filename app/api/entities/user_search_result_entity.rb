module Entities
  class UserSearchResultEntity < Grape::Entity
    expose :id
    expose :first_name
    expose :last_name
    expose :email
  end
end