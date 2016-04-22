FactoryGirl.define do
  factory :user do
    sequence :_id
    given_name 'User'
    family_name 'Name'
    email { "#{given_name}.#{family_name}@example.com" }
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

  factory :issue do
    user FactoryGirl.build :user
    type 'feedback'
    message 'This is the best fin tech app that I have seen in my life!'
    resolved true
  end

  factory :transaction do
    amount 100
    sent_at 3.days.ago
    received_at 1.day.ago
    partial false
  end
  factory :account do
    c SecureRandom.base64 256
    h SecureRandom.base64 256
  end

  factory :global_prefs do
    faq "<h3>Q: What is this app called?</h3><p> A: Crypt</p>"
    about 'Welcome to Crypt - a direct money-transfer application, allowing safe person-to-person currency transactions.'+
              '<br />With Crypt there is no middle man and no hidden fees, just simple on-the-go transfers made quickly and easily.'+
              '<br />Sending money, made easy.'
    privacy_policy 'See twitter\'s privacy policy'
    terms_and_conditions 'You must comply with all the terms and conditions as stated in the website'
    sharing_url 'https://twitter.com/crypttransfer'
    logo_url 'https://pbs.twimg.com/profile_images/653337369844817920/nj4CLtmB.png'
    graceful_error_message 'Oh fish! Something went wrong! Please bear with us, Thanks'
    supported_currencies [{from: :GBP, to: :ZAR}]
    app_tour_messages ({
        intro: '<h1>Howzit!</h1><p>Send money to South Africa from the palm of your hand.</p><p>Cheap | Fast | Safe</p>',
        steps: [
            '<h3>It’s quicker than making a Braii</h3>'+
                '<p>Create an account in seconds with your email address or connect using Facebook or Google. </p>',
            '<h3>Say goodbye to long waits in queue / No one likes waiting around in long queues</h3>'+
                '<p>Select the amount you want to send and get the really low transfer fees with the best exchange rate.</p>',
            '<h3> Because home is where the heart is</h3>'+
                '<p>Add your loved one’s details or simply choose from your phone book.</p>',
            '<h3>Payment and Chill? Safer than the Titanic</h3>'+ #todo review this sentence
                '<p>It’s easy to put in your payment details and relax knowing your money is secure.</p>',
        ]
    })
  end
end
