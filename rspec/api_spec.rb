ENV['RACK_ENV'] = 'test'
require 'bundler/setup'

Bundler.require(:default, :test)
# noinspection RubyArgCount
Dotenv.load
Mongoid.load!('mongoid.yml', :test)

require 'simplecov'
require 'simplecov-csv'
SimpleCov.formatter = SimpleCov::Formatter::CSVFormatter
SimpleCov.coverage_dir(ENV['COVERAGE_REPORTS'])
SimpleCov.start

require './api'

describe :API do
  include Rack::Test::Methods

  def app
    API
  end

  after :all do
    Transaction.collection.drop
  end

  context 'user is not authenticated' do
    it 'should return a 401 error' do
      get '/api/v1/transaction/history'
      expect(last_response.status).to eq 401
    end
  end
  context 'user is authenticated' do
    it 'should return the list of transactions' do
      Transaction.create!(
          sender: 'Somebody',
          receiver: 'Somebody',
          amount: '100',
          sent_at: Time.now,
          received_at: Time.now
      )

      env 'HTTP_AUTHORIZATION', "Bearer #{ENV['TEST_TOKEN']}"
      get '/api/v1/transaction/history'
      expect(last_response.status).to eq 200
      json_response = JSON.parse last_response.body
      expect(json_response.length).to eq 1
      expect(json_response[0]['amount']).to eq 100

    end
  end
end