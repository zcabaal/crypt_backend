module API
  class TransactionAPI < Grape::API
    resource :transaction do
      desc 'RESTful Api for dealing with transactions'
      resource :create do
        params do
          requires :amount, type: BigDecimal, non_negative: true
          optional :currency, type: Symbol, values: [:GBP], default: :GBP
          requires :payment_token, type: String
          optional :method, type: Symbol, values: [:stripe], default: :stripe
        end
        post do
          id = validate_token
          #todo validate payment token
          user = User.find id: id
          user.transactions << Transaction.new(
              amount: params.amount,
              token: SecureRandom.urlsafe_base64,
              payment_details: params,
              partial: true
          )
          {status: 'success'}
        end
      end
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