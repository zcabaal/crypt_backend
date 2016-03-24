describe API::TransactionAPI do

  describe 'POST create' do
    let(:payment_token) { 'This is a payment token that corresponds to a £100 payment' }
    let(:call_api) { post '/api/v1/transaction/create', amount: 100.0, payment_token: payment_token }
    it_behaves_like('a secure api')
    context 'user is authenticated' do
      before :each do
        @id = fake_authorization
      end

      it 'successfully creates a transaction when the payment token is valid' do
        create :sender, id: @id, transaction_amounts: []
        call_api
        transaction = User.find(id = @id).transactions.last
        expect(transaction.amount).to eq 100
        expect(transaction.partial).to be true
        expect(transaction.payment_details).to include("amount" => "100.0", "payment_token" => payment_token)
        expect(transaction.token).not_to be_nil
      end
      it 'returns a 400 when the payment token is valid'
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
    end
  end

end