describe API::TransactionAPI do

  describe 'POST create' do
    let(:payment_token) { 'This is a payment token that corresponds to a £100 payment' }
    let(:call_api) { post '/api/v1/transaction/create', amount: 100.0, payment_token: payment_token }
    let(:receiver_id) { 'This is the receiver id' }
    it_behaves_like('a secure api')
    context 'user is authenticated' do
      before :each do
        @id = fake_authorization
      end

      it 'successfully creates a transaction when the receiver is known' do
        create :sender, id: @id, transaction_amounts: []
        create :receiver, id: receiver_id
        post '/api/v1/transaction/create', amount: 100.0, payment_token: payment_token, receiver: receiver_id
        transaction = User.find(id = @id).transactions.last
        expect(transaction.amount).to eq 100
        expect(transaction.partial).to be false
        expect(transaction.payment_details).to include "payment_token" => payment_token
        expect(transaction.token).to be_nil
        expect(transaction.receiver).to eq receiver_id
      end
      it 'successfully creates a transaction when the payment token is valid' do
        create :sender, id: @id, transaction_amounts: []
        call_api
        json_response = JSON.parse last_response.body
        transaction = User.find(id = @id).transactions.last
        expect(transaction.amount).to eq 100
        expect(transaction.partial).to be true
        expect(transaction.payment_details).to include "payment_token" => payment_token
        expect(transaction.token).to eq json_response["token"]
      end
      it 'returns a 400 when the payment token is missing' do
        post '/api/v1/transaction/create', amount: 100.0
        expect(JSON.parse last_response.body).to include 'error' => 'payment_token is missing, payment_token is empty'
      end
      it 'returns a 400 when the amount is missing' do
        post '/api/v1/transaction/create', payment_token: payment_token
        expect(JSON.parse last_response.body).to include 'error' => 'amount is missing'
      end
      it 'returns a 400 when the payment token is not valid'
    end
  end
  describe 'GET history' do
    let(:call_api) { get '/api/v1/transaction/history' }
    it_behaves_like('a secure api')
    context 'user is authenticated' do
      before :each do
        @id = fake_authorization
      end
      it 'returns the list of transactions for the current user' do
        create :sender, id: @id, transaction_amounts: [100, 300]
        create :sender, transaction_amounts: [200, 400]
        call_api
        expect(last_response.status).to eq 200
        expect(JSON.parse last_response.body).to contain_exactly(a_hash_including('amount' => '100.0'),
                                                                 a_hash_including('amount' => '300.0'))
      end
      it 'only returns the required attributed (e.g receiver, amount) but not payment information and token' do
        create :sender, id: @id, transaction_amounts: [100]
        call_api
        json_response = JSON.parse last_response.body
        expect(json_response).to include(a_hash_including(
                                             "amount" => "100.0", "cap_reached" => anything, "completed" => anything,
                                             "received_at" => anything, "receiver" => anything, "refunded" => anything,
                                             "sent_at" => anything))
        expect(json_response).not_to include(a_hash_including('payment_details' => anything, 'token' => anything,
                                                              'duplicate_receiver' => anything, 'partial' => anything))
      end
      it 'supports pagination correctly' do
        create :sender, id: @id, transaction_amounts: 1..50
        get '/api/v1/transaction/history', per_page: 20
        json_response = JSON.parse last_response.body
        expect(json_response.count).to eq 20
        expect(json_response).to include(a_hash_including("amount" => "10.0"))
        expect(json_response).not_to include(a_hash_including("amount" => "21.0"))
        get '/api/v1/transaction/history', page: 3, per_page: 20
        json_response = JSON.parse last_response.body
        expect(json_response.count).to eq 10
        expect(json_response).to include(a_hash_including("amount" => "49.0"))
        expect(json_response).not_to include(a_hash_including("amount" => "31.0"))
        get '/api/v1/transaction/history', page: 5, per_page: 20
        json_response = JSON.parse last_response.body
        expect(json_response.count).to eq 0
      end
    end
  end

  describe 'GET recent_receivers' do
    let(:call_api) { get '/api/v1/transaction/recent_receivers' }
    it_behaves_like 'a secure api'

    context 'user is authenticated' do
      before :each do
        @id = fake_authorization
      end
      it 'returns a list of recent receivers' do
        receiver1 = 'receiver1'
        receiver2 = 'receiver2'
        user = create :sender, id: @id, transaction_amounts: [100, 300, 500]
        create :receiver, id: receiver1, given_name: 'John', family_name: 'Smith'
        create :receiver, id: receiver2
        user.transactions[0].receiver = receiver1
        user.transactions[1].receiver = receiver2
        user.transactions[2].partial = true
        user.save!
        call_api
        json_response = JSON.parse last_response.body
        expect(json_response).to include(
                                     a_hash_including(
                                         "_id" => receiver1, "given_name" => "John", "family_name" => "Smith"),
                                     a_hash_including(
                                         "_id" => receiver2, "given_name" => "User", "family_name" => "Name"),
                                 )
        expect(json_response).not_to include(
                                         a_hash_including(
                                             "email" => anything, "transactions" => anything, "accounts" => anything),
                                     )
      end
    end
  end
end