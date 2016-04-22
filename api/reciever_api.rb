module API
  class ReceiverAPI < Grape::API
    resource :receiver do
      resource :account do
        desc 'RESTful api for the receiver\'s account'
        get do
          @id = validate_token
          user = User.find id: @id
          {accounts: user.accounts.count}
        end
        params do
          requires :c, type: String, allow_blank: false
          requires :h, type: String, allow_blank: false
        end
        post do
          @id = validate_token
          user = User.find id: @id
          #todo check for the uniqueness of accounts
          user.accounts << Account.new(c: params.c, h: Gibberish::SHA512(params.h))
          {accounts: user.accounts.count}
        end
      end
      resource :transaction do
        params do
          requires :token, type: String, allow_blank: false
        end
        post do
          @id = validate_token
          # src: http://stackoverflow.com/questions/23596929/how-to-use-projections-in-mongoid todo find a better way
          user = User.where('transactions.token': params.token).first
          error! 'Invalid transaction token', 400 if user.nil?
          transaction = user.transactions.where('token': params.token).first
          error! 'Invalid transaction token', 400 unless transaction.receiver.nil? or transaction.receiver == @id
          transaction.receiver = @id
          transaction.partial = false
          transaction.save!
        end
      end
    end
  end
end