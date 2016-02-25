describe User do

  it_behaves_like('a model') do
    subject { build :user }
  end

  describe 'Sender' do
    it_behaves_like('a model') do
      subject { build :sender }
    end
    it 'allows creating transactions as long as they do not hit the cap'
    it 'rejects transactions when the cap is reached'
  end
  describe 'Receiver' do
    it_behaves_like('a model') do
      subject { build :receiver }
    end
    context 'duplicate receiver' do
      it 'rejects the accounts if they belong to another receiver'
    end
  end
end