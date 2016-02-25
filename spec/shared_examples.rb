shared_examples_for ('a secure api') do

  context 'user is not authenticated' do
    it 'returns a 401 error' do
      call_api
      expect(last_response.status).to eq 401
    end
  end
end

shared_examples_for ('a model') do
  it 'is a valid model' do
    expect(subject).to be_valid
  end
end