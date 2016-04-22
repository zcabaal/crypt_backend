describe API::IssueAPI do

  describe 'POST issue' do
    let(:message) { 'This is a message' }
    let(:email) { 'domain@example.com' }
    let(:call_api) { post '/api/v1/issue', message: message, email: email }

    context 'user is anonymous' do
      it 'creates an issue correctly if message and email are provided' do
        call_api
        issue = Issue.first
        expect(issue.user).to be_nil
        expect(issue.type).to eq 'support'
        expect(issue.message).to eq message
        expect(issue.email).to eq email
        expect(issue.resolved).to be false
      end
      it 'returns a 400 if no message is provided' do
        post '/api/v1/issue', email: email
        expect(JSON.parse last_response.body).to include 'error' => 'message is missing, message is empty'
      end
      it 'returns a 400 if no email is provided' do
        post '/api/v1/issue', message: message
        expect(JSON.parse last_response.body).to include 'error' => 'email is missing, email is empty, email is not valid'
      end
    end

    context 'user is authenticated' do
      it 'creates an issue correctly if message is provided' do
        @id = fake_authorization
        create :user, id: @id
        call_api
        issue = Issue.first
        expect(issue.user.id).to eq @id
        expect(issue.type).to eq 'support'
        expect(issue.message).to eq message
        expect(issue.email).to eq email
        expect(issue.resolved).to be false
      end
      it 'returns a 401 if token is incorrect' do
        env 'HTTP_AUTHORIZATION', "Bearer <some_invalid_token>"
        call_api
        expect(last_response.status).to eq 401
      end
    end
  end
end