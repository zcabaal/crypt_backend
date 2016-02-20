require './spec/shared_examples/a_secure_api'

describe :TransactionAPI do

  def app
    API::Transaction
  end

  after :all do
    Models::Transaction.collection.drop
  end
  describe 'GET :history' do
    it_behaves_like('a secure api') do
      let(:call_api) { get '/api/v1/transaction/history' }
    end
    context 'user is authenticated' do
      let (:query) { [{
                          "sender" => 'Somebody',
                          "receiver" => 'Somebody',
                          "amount" => '100',
                          "sent_at" => Time.now.to_s,
                          "received_at" => Time.now.to_s
                      }] }
      it 'should return the list of transactions' do

        #Models::Transaction.create!(
        #    sender: 'Somebody',
        #    receiver: 'Somebody',
        #    amount: '100',
        #    sent_at: Time.now,
        #    received_at: Time.now
        #)
        allow(Models::Transaction).to receive(:all).and_return(query)
        allow(JWT).to receive(:decode).and_return([{'aud' => ENV['AUTH0_CLIENT_ID'], 'sub' => 'facebook|1234567889'}])
        env 'HTTP_AUTHORIZATION', "Bearer <some_valid_token>"
        get '/api/v1/transaction/history'
        expect(last_response.status).to eq 200
        json_response = JSON.parse last_response.body
        expect(json_response).to eq query

      end
    end
  end

end