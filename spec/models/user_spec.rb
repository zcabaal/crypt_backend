require 'rspec'

describe Models::User do

  it 'has a username which is a string' do
    subject.username = 'test'
    expect(subject).to be_valid
  end
  # it has ... (other attributes)


  describe Models::Sender do
    it 'has a list of transactions embedded in it' do
      subject.transactions = [Models::Transaction.new]
      expect(subject).to be_valid
    end
    it 'allows creating transactions as long as they do not hit the cap'
    it 'rejects transactions when the cap is reached'
  end
  describe Models::Sender do
    it 'allows storing encrypted accounts'
    context 'duplicate receiver' do
      it 'rejects the accounts if they belong to another receiver'
    end
  end
end