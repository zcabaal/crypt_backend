class TransactionSerializer < ActiveModel::Serializer
  attributes :amount, :cap_reached, :completed, :received_at, :receiver, :refunded, :sent_at
end