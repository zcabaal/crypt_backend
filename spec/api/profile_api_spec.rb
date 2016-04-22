describe API::ProfileAPI do
  describe 'GET profile' do

    let(:call_api) { get '/api/v1/profile' }
    it_behaves_like 'a secure api'

    context 'user is authenticated' do
      before :each do
        @id = fake_authorization
      end
      it 'returns correct given name and family name' do
        create :user, id: @id
        call_api
        expect(JSON.parse last_response.body).to include("given_name" => "User", "family_name" => "Name")
      end
      it 'returns an empty response when user does not have a give name and family name' do
        User.create id: @id
        call_api
        expect(last_response.status).to eq 200
      end
    end
  end
  describe 'PUT profile' do
    let(:email) { 'domain@example.com' }
    let(:given_name) { 'John' }
    let(:family_name) { 'Smith' }
    let(:call_api) { put '/api/v1/profile', email: email, given_name: given_name, family_name: family_name }
    it_behaves_like 'a secure api'

    context 'user is authenticated' do
      before :each do
        @id = fake_authorization
      end

      it 'correctly updates the profile when all parameters are supplied' do
        create :user, id: @id
        call_api
        user = User.find id: @id
        expect(user.email).to eq email
        expect(user.given_name).to eq given_name
        expect(user.family_name).to eq family_name
      end
      it 'returns a 400 when one of the parameters is missing' do
        put '/api/v1/profile', given_name: given_name, family_name: family_name
        expect(last_response.status).to eq 400
        expect(JSON.parse last_response.body).to include 'error' => 'email is missing, email is empty, email is not valid'
        put '/api/v1/profile', email: email, family_name: family_name
        expect(last_response.status).to eq 400
        expect(JSON.parse last_response.body).to include 'error' => 'given_name is missing, given_name is empty'
        put '/api/v1/profile', email: email, given_name: given_name
        expect(last_response.status).to eq 400
        expect(JSON.parse last_response.body).to include 'error' => 'family_name is missing, family_name is empty'
      end
      it 'returns a 400 when email is invalid' do
        put '/api/v1/profile', email: '@invalid', given_name: given_name, family_name: family_name
        expect(last_response.status).to eq 400
        expect(JSON.parse last_response.body).to include 'error' => 'email is not valid'
      end
    end
  end
end