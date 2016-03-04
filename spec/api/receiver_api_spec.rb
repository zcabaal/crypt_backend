describe API::ReceiverAPI do
  def app
    API::ReceiverAPI
  end

  describe 'POST add_account' do

    let(:c) { 'this is a c' }
    let(:h) { 'this is a h' }

    let(:call_api) { post '/api/v1/receiver/add_account', c: c, h: h }

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
        expect(last_response.status).to eq 201
        expect(account.c).to eq c
        expect(account.h).to eq Gibberish::SHA512(h)
      end

      let(:call_api_with_token) { post '/api/v1/receiver/add_account', c: c, h: h, token: token }
      let(:token) { 'this is a token' }
      let(:sender_id) { 'sender id' }
      it 'updates the corresponding transaction (if token is supplied)' do
        sender = create :sender, id: sender_id, transaction_amounts: [100]
        transaction = sender.transactions.last
        transaction.token = token
        transaction.partial = true
        transaction.save!
        call_api_with_token
        sender = User.find id: sender_id
        transaction = sender.transactions.last
        expect(transaction.receiver).to eq @id
        expect(transaction.partial).to be false
      end
      it 'returns a 400 when the required parameters are not supplied' do
        post '/api/v1/receiver/add_account'
        expect(last_response.status).to eq 400
        expect(JSON.parse last_response.body).to include 'error' => 'c is missing, h is missing'
      end
      it 'returns a 400 when the token is not found' do
        call_api_with_token
        expect(last_response.status).to eq 400
        expect(JSON.parse last_response.body).to include 'error' => 'Invalid transaction token'
      end
      it 'returns a 400 when the the transaction belongs to another revceiver' do
        sender = create :sender, id: sender_id, transaction_amounts: [100]
        transaction = sender.transactions.last
        transaction.token = token
        transaction.receiver = 'some other person'
        transaction.save!
        call_api_with_token
        expect(last_response.status).to eq 400
        expect(JSON.parse last_response.body).to include 'error' => 'Invalid transaction token'
      end
      it 'returns 400 when the account already exists'
    end
  end
end