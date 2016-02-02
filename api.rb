require './models'

class API < Grape::API
  version :v1, using: :path
  format :json
  default_format :json
  prefix :views

  use Rack::Session::Cookie, secret: ENV['SESSION_SECRET']
  use OmniAuth::Builder do
    provider :auth0, ENV['AUTH0_CLIENT_ID'], ENV['AUTH0_CLIENT_SECRET'], ENV['AUTH0_DOMAIN']
  end

  helpers do
    def validate_token
      begin
        auth0_client_id = ENV['AUTH0_CLIENT_ID']
        auth0_client_secret = ENV['AUTH0_CLIENT_SECRET']
        authorization = env['HTTP_AUTHORIZATION']
        error! 'Not Authorized', 401 if authorization.nil?
        token = env['HTTP_AUTHORIZATION'].split(' ').last
        decoded_token = JWT.decode(token,
                                   JWT.base64url_decode(auth0_client_secret))
        error! 'Not Authorized', 401 if auth0_client_id != decoded_token[0]['aud']
      rescue JWT::ExpiredSignature
        puts 'Expired Signature'
      rescue JWT::DecodeError => e
        puts e.inspect
        error! 'Not Authorized', 401
      end
    end
  end

  resource :transaction do
    desc 'RESTful Api for dealing with transactions'
    resource :history do
      desc 'List endpoint for retrieving the transaction history for the current user'
      get do
        validate_token
        Transaction.all
      end
    end
  end
end