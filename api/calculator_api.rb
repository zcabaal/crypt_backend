module API
  class CalculatorAPI < Grape::API
    resource :calculator do
      desc 'RESTful Api for dealing with price calculations'

      resource :calculate do
        params do
          optional :from_amount, type: BigDecimal, non_negative: true
          optional :to_amount, type: BigDecimal, non_negative: true
          optional :from_currency, type: Symbol, values: [:GBP], default: :GBP
          optional :to_currency, type: Symbol, values: [:ZAR], default: :ZAR
          optional :promo_code, type: Symbol, values: []
          exactly_one_of :from_amount, :to_amount
        end
        post do
          if params.to_amount.nil?
            from_amount = Money.from_amount(params.from_amount, params.from_currency)
            to_amount = from_amount.exchange_to(params.to_currency)
          else
            to_amount = Money.from_amount(params.to_amount, params.to_currency)
            from_amount = to_amount.exchange_to(params.from_currency)
          end
          fee = Money.from_amount(1, params.from_currency) #todo change this placeholder
          {from_amount: from_amount.format, to_amount: to_amount.format, fee: fee.format, price: (from_amount+fee).format}
        end
      end
    end
  end
end