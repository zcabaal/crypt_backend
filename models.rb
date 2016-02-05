module Models
  class Transaction
    include Mongoid::Document

    field :sender, type: String
    field :receiver, type: String
    field :amount, type: Float
    field :sent_at, type: DateTime
    field :received_at, type: DateTime
  end
end