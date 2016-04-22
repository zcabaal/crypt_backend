module API
  class TransactionAPI < Grape::API
    resource :transaction do
      resource :create do
        params do
          requires :amount, type: BigDecimal, non_negative: true
          optional :currency, type: Symbol, values: [:GBP], default: :GBP
          requires :payment_token, type: String, allow_blank: false
          optional :receiver, type: String
          optional :payment_method, type: Symbol, values: [:stripe], default: :stripe
        end
        post do
          id = validate_token
          #todo validate payment token
          user = User.find id: id
          token = nil
          partial = false
          response = {status: 'success'}
          if params.receiver.nil?
            token = SecureRandom.urlsafe_base64 64
            partial = true
            response = {token: token}
          end
          user.transactions << Transaction.new(
              amount: params.amount,
              receiver: params.receiver,
              token: token,
              payment_details: {payment_token: params.payment_token, payment_method: params.payment_method},
              partial: partial
          )
          response
        end
      end
      resource :history do
        desc 'List endpoint for retrieving the transaction history for the current user'
        paginate
        get do
          id = validate_token
          user = User.find id: id
          user.transactions.page(params.page).per(params.per_page)
        end
      end
      resource :recent_receivers do
        desc 'List endpoint for retrieving the recent receivers for the current user'
        get do
          id = validate_token
          user = User.find id: id
          user.transactions.where(partial: false).map do |transaction|
            User.find id: transaction.receiver
          end
        end
      end
    end
  end
end