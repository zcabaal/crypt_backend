ENV['RACK_ENV'] = 'test'
require 'simplecov'
require 'simplecov-csv'
SimpleCov.formatter = SimpleCov::Formatter::CSVFormatter
SimpleCov.coverage_dir(ENV['COVERAGE_REPORTS'])
SimpleCov.start

require 'bundler/setup'

Bundler.require(:default, :test)
# noinspection RubyArgCount
Dotenv.load
Mongoid.load!('mongoid.yml', :test)
FactoryGirl.lint

require './require'
require_relative 'factories'
require_relative 'shared_examples'

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods
  config.before(:each) do
    Mongoid.purge!
  end
end

def app
  API::Root
end

def fake_authorization(id='facebook|my_user_id')
  allow(JWT).to receive(:decode).and_return([{'aud' => ENV['AUTH0_CLIENT_ID'], 'sub' => id}])
  env 'HTTP_AUTHORIZATION', "Bearer <some_valid_token>"
  id
end