module Models
  class Lists < Grape::API
    format :json
    desc "Endpoints for lists"

    namespace :lists do
      namespace :create do
        desc "Create a new list"
        params do
          requires :token, type: String, desc: "token"
          requires :name, type: String, desc: "list name"
          requires :user_ids, type: Array, desc: "list of friends"
        end

        post do
          authenticate!

          list = List.new({name: params[:name], user_ids: params[:user_ids]})
          list.user = @current_user

          if list.save
            listUser = ListUser.new(list: list, user: @current_user)
            listUser.save

            status 200
            present list, with: Entities::ListEntity
          else
            error!({"error_msg" => "Cannot create list."}, 400)
          end
        end
      end

      namespace :delete do
        desc "Delete a list"
        params do
          requires :token, type: String, desc: "token"
          requires :id, type: String, desc: "list id"
        end

        post do
          authenticate!

          list = List.find(params[:id])

          if list.user.id == @current_user.id
            list.list_users.each do |list_user|
              list_user.destroy
            end

            list.destroy

            status 200
            present @current_user, with: Entities::UserWithTokenEntity
          else
            error!({"error_msg" => "Not allowed."}, 403)
          end
        end
      end

      namespace :index do
        desc "List all lists of a user"
        params do
          requires :token, type: String, desc: "token"
        end

        get do
          authenticate!

          status 200
          present @current_user.lists, with: Entities::ListEntity
        end
      end

      namespace :items do
        namespace :create do
          desc "Create a new item"
          params do
            requires :token, type: String, desc: "token"
            requires :list_id, type: String, desc: "list id"
            requires :name, type: String, desc: "item name"
            requires :due_date, type: String, desc: "due date"
          end

          post do
            authenticate!

            list = List.find(params[:list_id])

            if list && list.user_id == @current_user.id
              begin
                puts "DUE DATE: #{params[:due_date]}"
                due_date = DateTime.strptime(params[:due_date], "%Y-%m-%d %H:%M:%S%z")
                item = Item.create!({name: params[:name], due_date: due_date, list_id: list.id})

                present item, with: Entities::ItemEntity
              rescue ArgumentError
                error!({"error_msg" => "Wrong date argument."}, 400)
              end
            else
              error!({"error_msg" => "Cannot find list."}, 400)
            end
          end
        end

        namespace :delete do
          desc "Delete an item"
          params do
            requires :token, type: String, desc: "token"
            requires :list_id, type: String, desc: "list id"
            requires :item_id, type: String, desc: "item id"
          end

          post do
            authenticate!

            list = List.find(params[:list_id])

            if list && list.user_id == @current_user.id
              item = Item.find(params[:item_id])

              if item.list_id == list.id
                item.destroy

                status 200
                present list, with: Entities::ListEntity
              else
                error!({"error_msg" => "Cannot find item."}, 400)
              end
            else
              error!({"error_msg" => "Cannot find list."}, 400)
            end
          end
        end

        namespace :toggle_state do
          desc "Toggle the state of an item"
          params do
            requires :token, type: String, desc: "token"
            requires :list_id, type: String, desc: "list id"
            requires :item_id, type: String, desc: "item id"
            requires :state, type: String, desc: "item state"
          end

          post do
            authenticate!

            begin
              list = List.find(params[:list_id])

              if list && list.user_id == @current_user.id
                item = Item.find(params[:item_id])

                if item.list_id == list.id
                  is_done = params[:state] == "1"

                  item.is_done = is_done
                  item.completed_by = is_done ? @current_user : nil
                  item.completed_at = is_done ? DateTime.now : nil
                  item.save

                  status 200
                  present item, with: Entities::ItemEntity
                else
                  error!({"error_msg" => "Cannot find item."}, 400)
                end
              else
                error!({"error_msg" => "Cannot find list."}, 400)
              end
            rescue ActiveRecord::RecordNotFound
              error!({"error_msg" => "Cannot find record."}, 400)
            end
          end
        end


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