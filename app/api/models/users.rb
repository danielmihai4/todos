module Models
  class Users < Grape::API
    format :json
    desc "Endpoints for users"

    namespace :users do
      namespace :update do
        desc "Update first and last name"
        params do
          requires :token, type: String, desc: "token"
          requires :first_name, type: String, desc: "first name"
          requires :last_name, type: String, desc: "last name"
        end

        post do
          authenticate!

          @current_user.update!({first_name: params[:first_name], last_name: params[:last_name]})

          status 200
          present @current_user, with: Entities::UserWithTokenEntity
        end
      end

      namespace :search_users do
        desc "Find users based on search query"
        params do
          requires :token, type: String, desc: "token"
          requires :query, type: String, desc: "query string"
        end

        post do
          authenticate!

          users = User.search(params[:query])
          users = @current_user.strangers(users)

          status 200
          present users, with: Entities::UserSearchResultEntity
        end
      end

      namespace :add_friendship do
        desc "Add friendship"
        params do
          requires :token, type: String, desc: "token"
          requires :user_id, type: String, desc: "user to be befriended"
        end

        post do
          authenticate!

          begin
            friend = User.find(params[:user_id])

            @current_user.friendships.build(friend_id: friend.id)
            if @current_user.save
              status 200
              present @current_user, with: Entities::UserWithTokenEntity
            else
              error!({"error_msg" => "Something went wrong."}, 400)
            end
          rescue ActiveRecord::RecordNotFound => exception
            error!({"error_msg" => "Cannot find user."}, 400)
          end
        end
      end

      namespace :remove_friendship do
        desc "Remove friendship"
        params do
          requires :token, type: String, desc: "token"
          requires :user_id, type: String, desc: "user to be unfriended"
        end

        post do
          authenticate!

          friendship = @current_user.friendships.where(friend_id: params[:user_id]).first

          if friendship
            friendship.destroy

            status 200
            present @current_user, with: Entities::UserWithTokenEntity
          else
            error!({"error_msg" => "Cannot unfriend user."}, 404)
          end
        end
      end

      namespace :friends do
        desc "Get a user's friends"
        params do
          requires :token, type: String, desc: "token"
        end

        get do
          authenticate!

          status 200
          present @current_user.friends, with: Entities::UserSearchResultEntity
        end
      end

      helpers do
        def authenticate!
          error!("Unauthorized. Invalid or expired token", 401) unless current_user
        end

        def current_user
          if @current_user
            return true
          end

          token = AuthenticationToken.valid.where(token: params[:token]).first

          if token
            @current_user = token.user
          end

          return @current_user
        end
      end
    end
  end
end