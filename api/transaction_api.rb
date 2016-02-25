module API
  class TransactionAPI < Grape::API
    resource :transaction do
      desc 'RESTful Api for dealing with transactions'
      resource :history do
        desc 'List endpoint for retrieving the transaction history for the current user'
        get do
          id = validate_token
          user = User.find id: id
          user.transactions
        end
      end
    end
  end
end