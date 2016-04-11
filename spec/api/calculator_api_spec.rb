describe API::CalculatorAPI do

  describe 'POST calculate' do
    let(:call_api_with_from_amount) { post '/api/v1/calculator/calculate', from_amount: 100 }
    let(:call_api_with_to_amount) { post '/api/v1/calculator/calculate', from_amount: 100 }
    Money.default_bank = Money::Bank::VariableExchange.new(Money::RatesStore::Memory.new)
    Money.default_bank.add_rate(:GBP, :ZAR, 20)
    Money.default_bank.add_rate(:ZAR, :GBP, 1.0/20)
    it 'calculate the price correctly given from amount' do
      post '/api/v1/calculator/calculate', from_amount: 100
      expect(JSON.parse last_response.body).to include('from_amount' => '£100.00', 'to_amount' => 'R2,000.00',
                                                       'fee' => '£1.00', 'price' => '£101.00')
    end
    it 'calculate the price correctly given to amount' do
      post '/api/v1/calculator/calculate', to_amount: 2000
      expect(JSON.parse last_response.body).to include('from_amount' => '£100.00', 'to_amount' => 'R2,000.00',
                                                       'fee' => '£1.00', 'price' => '£101.00')
    end
    it 'returns a 400 when both from_amount and to_amount are supplied' do
      post '/api/v1/calculator/calculate', from_amount: 100, to_amount: 2000
      expect(last_response.status).to eq 400
      expect(JSON.parse last_response.body).to include 'error' => 'from_amount, to_amount are mutually exclusive'
    end
    it 'returns a 400 when no amounts are given' do
      post '/api/v1/calculator/calculate'
      expect(last_response.status).to eq 400
      expect(JSON.parse last_response.body).to include 'error' => 'from_amount, to_amount are missing, exactly one parameter must be provided'
    end
    it 'returns a 400 when from_amount is negative' do
      post '/api/v1/calculator/calculate', from_amount: -100
      expect(last_response.status).to eq 400
      expect(JSON.parse last_response.body).to include 'error' => 'from_amount cannot be negative'
    end
    it 'returns a 400 when to_amount is negative' do
      post '/api/v1/calculator/calculate', to_amount: -2000
      expect(last_response.status).to eq 400
      expect(JSON.parse last_response.body).to include 'error' => 'to_amount cannot be negative'
    end
    it 'returns a 400 when promo_code is not valid' do
      post '/api/v1/calculator/calculate', to_amount: 1, promo_code: 'invalid'
      expect(last_response.status).to eq 400
      expect(JSON.parse last_response.body).to include 'error' => 'promo_code does not have a valid value'
    end
  end
end