module Models
  class User
    include Mongoid::Document
    field :username, type: String
  end

  class Sender < User
    embeds_many :transactions
  end
  class Receiver < User
    embeds_many :accounts
  end
  class Transaction
    include Mongoid::Document

    field :receiver, type: String
    field :amount, type: BigDecimal
    field :sent_at, type: DateTime
    field :received_at, type: DateTime
    embedded_in :sender
  end

  class Account
    include Mongoid::Document

    field :token1, type: String
    field :token2, type: String
    embedded_in :receiver
  end
end