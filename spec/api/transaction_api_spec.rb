describe API::TransactionAPI do

  def app
    API::TransactionAPI
  end

  describe 'GET :history' do
    it_behaves_like('a secure api') do
      let(:call_api) { get '/api/v1/transaction/history' }
    end
    context 'user is authenticated' do
      before :example do
        @id = fake_authorization
      end
      it 'should return the list of transactions for the current user' do
        create :sender, id: @id, transaction_amounts: [100, 300]
        create :sender, transaction_amounts: [200, 400]
        get '/api/v1/transaction/history'
        expect(last_response.status).to eq 200
        json_response = JSON.parse last_response.body
        expect(json_response).to contain_exactly(a_hash_including('amount' => '100.0'),
                                                 a_hash_including('amount' => '300.0'))
      end
    end
  end

end