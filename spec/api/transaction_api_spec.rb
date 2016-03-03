describe API::TransactionAPI do

  def app
    API::TransactionAPI
  end

  describe 'GET :history' do
    it_behaves_like('a secure api') do
      let(:call_api) { get '/api/v1/transaction/history' }
    end
    context 'user is authenticated' do
      before :each do
        @id = fake_authorization
      end
      it 'returns the list of transactions for the current user' do
        create :sender, id: @id, transaction_amounts: [100, 300]
        create :sender, transaction_amounts: [200, 400]
        get '/api/v1/transaction/history'
        expect(last_response.status).to eq 200
        json_response = JSON.parse last_response.body
        expect(json_response).to contain_exactly(a_hash_including('amount' => '100.0'),
                                                 a_hash_including('amount' => '300.0'))
      end
      it 'only returns the required attributed (e.g receiver, amount) but not payment information and token' do
        create :sender, id: @id, transaction_amounts: [100]
        get '/api/v1/transaction/history'
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