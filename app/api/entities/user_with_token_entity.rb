module Entities
    class UserWithTokenEntity < UserEntity
        expose :token do |user, options|
          user.authentication_tokens.valid.first.token
        end
    end
end