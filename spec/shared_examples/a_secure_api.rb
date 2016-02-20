shared_examples_for ('a secure api') do

  context 'user is not authenticated' do
    it 'should return a 401 error' do
      call_api
      expect(last_response.status).to eq 401
    end
  end
end