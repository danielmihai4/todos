module Auth
  class Ping < Grape::API
    format :json

    namespace :ping do
      desc "Returns pong if logged in correctly"
      params do
        requires :token, type: String, desc: "Access token."
      end

      get do
        authenticate!
        {"message" => "pong"}
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