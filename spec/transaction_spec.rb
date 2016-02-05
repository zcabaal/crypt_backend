require_relative 'spec_helper'

describe :TransactionAPI do

  def app
    API::Transaction
  end

  after :all do
    Models::Transaction.collection.drop
  end

  context 'user is not authenticated' do
    it 'should return a 401 error' do
      get '/api/v1/transaction/history'
      expect(last_response.status).to eq 401
    end
  end
  context 'user is authenticated' do
    it 'should return the list of transactions' do
      Models::Transaction.create!(
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