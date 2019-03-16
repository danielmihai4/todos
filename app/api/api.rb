class API < Grape::API
  prefix "api"
  mount Auth::Login
  mount Auth::Ping
  mount Auth::SignUp

  mount Models::Users
  mount Models::Lists

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    rack_response({status: e.status, error_msg: e.message}.to_json, 400)
  end

end