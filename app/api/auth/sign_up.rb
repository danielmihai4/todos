module Auth
  class SignUp < Grape::API
    format :json
    desc "Endpoints for signing up"
    namespace :sign_up do
      desc "Sign up with email and password"
      params do
        requires :email, type: String, desc: "email"
        requires :password, type: String, desc: "password"
      end

      post do
        user = User.find_by_email params[:email]

        if user == nil
          user = User.create!({
                    email: params[:email],
                    password: params[:password],
                    first_name: params[:first_name],
                    last_name: params[:last_name]})

          token = user.authentication_tokens.valid.first || AuthenticationToken.create!({user: user})

          status 200

          present token.user, with: Entities::UserWithTokenEntity
        else
          error!({"error_msg" => "Email already registered"}, 401)
        end
      end
    end
  end
end