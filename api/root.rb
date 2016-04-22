Dir['./api/*.rb'].each { |f| require f }

module API
  class Root < Grape::API
    version :v1, using: :path
    format :json
    formatter :json, Grape::Formatter::ActiveModelSerializers
    default_format :json
    prefix :api

    use Rack::Session::Cookie, secret: ENV['SESSION_SECRET']
    use OmniAuth::Builder do
      provider :auth0, ENV['AUTH0_CLIENT_ID'], ENV['AUTH0_CLIENT_SECRET'], ENV['AUTH0_DOMAIN']
    end

    helpers do
      def default_serializer_options
        {root: false}
      end
      def validate_token
        begin
          auth0_client_id = ENV['AUTH0_CLIENT_ID']
          auth0_client_secret = ENV['AUTH0_CLIENT_SECRET']
          authorization = env['HTTP_AUTHORIZATION']
          error! 'Not Authorized', 401 if authorization.nil?
          token = env['HTTP_AUTHORIZATION'].split(' ').last
          decoded_token = JWT.decode(token, JWT.base64url_decode(auth0_client_secret))
          error! 'Not Authorized', 401 if auth0_client_id != decoded_token[0]['aud']
          return decoded_token[0]['sub']
        rescue JWT::DecodeError => e
          puts e.inspect
          error! 'Not Authorized', 401
        end
      end
    end

    mount API::TransactionAPI
    mount API::ReceiverAPI
    mount API::CalculatorAPI
    mount API::GlobalPrefsAPI
    mount API::IssueAPI
    mount API::ProfileAPI
  end
end