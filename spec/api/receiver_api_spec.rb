describe API::ReceiverAPI do

  describe 'GET account' do
    let(:call_api) { get '/api/v1/receiver/account' }

    it_behaves_like 'a secure api'

    context 'user is authenticated' do
      before :each do
        @id = fake_authorization
      end
      it 'returns the correct number of accounts for the receiver' do
        user = create :receiver, id: @id
        call_api
        expect(JSON.parse last_response.body).to include "accounts" => 1
        user.accounts << Account.new
        get '/api/v1/receiver/account'
        expect(JSON.parse last_response.body).to include "accounts" => 2
      end
    end
  end
  describe 'POST account' do

    let(:c) { 'this is a c' }
    let(:h) { 'this is a h' }

    let(:call_api) { post '/api/v1/receiver/account', c: c, h: h }

    it_behaves_like 'a secure api'

    context 'user is authenticated' do
      before :each do
        @id = fake_authorization
        create :receiver, id: @id
      end
      it 'creates an account for the user when supplied with correct parameters' do
        call_api
        user = User.find id: @id
        account = user.accounts.last
        expect(JSON.parse last_response.body).to include "accounts" => 2
        expect(account.c).to eq c
        expect(account.h).to eq Gibberish::SHA512(h)
      end

      it 'returns a 400 when the required parameters are missing' do
        post '/api/v1/receiver/account'
        expect(last_response.status).to eq 400
        expect(JSON.parse last_response.body).to include 'error' => 'c is missing, c is empty, h is missing, h is empty'
      end
      it 'returns 400 when the account already exists'
    end
  end

  describe 'POST transaction' do
    let(:token) { 'this is a token' }
    let(:sender_id) { 'sender id' }
    let(:call_api) { post '/api/v1/receiver/transaction', token: token }
    it_behaves_like 'a secure api'

    context 'user is authenticated' do
      before :each do
        @id = fake_authorization
        create :receiver, id: @id
      end
      it 'updates the corresponding transaction' do
        sender = create :sender, id: sender_id, transaction_amounts: [100]
        transaction = sender.transactions.last
        transaction.token = token
        transaction.partial = true
        transaction.save!
        call_api
        sender = User.find id: sender_id
        transaction = sender.transactions.last
        expect(transaction.receiver).to eq @id
        expect(transaction.partial).to be false
      end
      it 'returns a 400 when the the transaction belongs to another receiver' do
        sender = create :sender, id: sender_id, transaction_amounts: [100]
        transaction = sender.transactions.last
        transaction.token = token
        transaction.receiver = 'some other person'
        transaction.save!
        call_api
        expect(last_response.status).to eq 400
        expect(JSON.parse last_response.body).to include 'error' => 'Invalid transaction token'
      end
      it 'returns a 400 when the token is not found' do
        call_api
        expect(last_response.status).to eq 400
        expect(JSON.parse last_response.body).to include 'error' => 'Invalid transaction token'
      end
      it 'returns a 400 when the no token is missing' do
        post '/api/v1/receiver/transaction'
        expect(last_response.status).to eq 400
        expect(JSON.parse last_response.body).to include 'error' => 'token is missing, token is empty'
      end
    end
  end
end