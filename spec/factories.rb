FactoryGirl.define do
  factory :user do
    sequence :_id
    factory :sender do
      transient do
        transaction_amounts [100, 200]
      end
      after(:build) do |user, evaluator|
        user.transactions = evaluator.transaction_amounts.map do |i|
          build(:transaction, amount: i)
        end
      end
    end
    factory :receiver do
      after(:build) do |user|
        user.accounts = [build(:account)]
      end
    end
  end

  factory :transaction do
    amount 100
    sent_at 3.days.ago
    received_at 1.day.ago
  end
  factory :account do
    c SecureRandom.base64 256
    h SecureRandom.base64 256
  end
end
