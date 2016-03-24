module API
  class ReceiverAPI < Grape::API
    resource :receiver do
      resource :add_account do
        desc 'Create an account for the receiver, and link it to a transaction if the transaction token supplied'
        params do
          requires :c, type: String
          requires :h, type: String
          optional :token, type: String
        end
        post do
          @id = validate_token
          unless params.token.nil?
            # src: http://stackoverflow.com/questions/23596929/how-to-use-projections-in-mongoid todo find a better way
            user = User.where('transactions.token': params.token).first
            error! 'Invalid transaction token', 400 if user.nil?
            transaction = user.transactions.where('token': params.token).first
            error! 'Invalid transaction token', 400 unless transaction.receiver.nil? or transaction.receiver == @id
            transaction.receiver = @id
            transaction.partial = false
            transaction.save!
          end
          user = User.find id: @id
          #todo check for the uniqueness of accounts
          user.accounts << Account.new(c: params.c, h: Gibberish::SHA512(params.h))
          {status: 'success'}
        end
      end
    end
  end
end