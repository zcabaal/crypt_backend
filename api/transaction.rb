module API
  class Transaction < Grape::API
    resource :transaction do
      desc 'RESTful Api for dealing with transactions'
      resource :history do
        desc 'List endpoint for retrieving the transaction history for the current user'
        get do
          validate_token
          Models::Transaction.all
        end
      end
    end
  end
end