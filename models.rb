class User
  include Mongoid::Document
  field :username, type: String
  embeds_many :transactions
  embeds_many :accounts
end

class Transaction
  include Mongoid::Document

  field :receiver, type: String
  field :amount, type: BigDecimal
  field :sent_at, type: DateTime
  field :received_at, type: DateTime
  field :token, type: String
  field :payment_details, type: String
  field :partial, type: Boolean
  field :completed, type: Boolean
  field :cap_reached, type: Boolean
  field :duplicate_receiver, type: Boolean
  field :refunded, type: Boolean
  embedded_in :user
end

class Account
  include Mongoid::Document

  field :c, type: String
  field :h, type: String
  field :duplicate, type: Boolean
  field :duplicate_with, type: BSON::ObjectId
  embedded_in :user
end
