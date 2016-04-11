describe API::IssueAPI do

  describe 'POST issue' do
    let(:message) { 'This is a message' }
    let(:call_api) { post '/api/v1/issue', message: message }

    it_behaves_like 'a secure api'

    context 'user is authenticated' do
      before :each do
        @id = fake_authorization
        create :user, id: @id
      end
      it 'creates an issue correctly if message is provided' do
        call_api
        issue = Issue.first
        expect(issue.user.id).to eq @id
        expect(issue.type).to eq 'support'
        expect(issue.message).to eq message
        expect(issue.resolved).to be false
      end
      it 'returns a 400 if no message is provided' do
        post '/api/v1/issue'
        expect(JSON.parse last_response.body).to include 'error' => 'message is missing'
      end
    end
  end
end