class UserSerializer < ActiveModel::Serializer
  attributes :_id, :given_name, :family_name
end

class TransactionSerializer < ActiveModel::Serializer
  attributes :amount, :cap_reached, :completed, :received_at, :receiver, :refunded, :sent_at
end

class GlobalPrefsSerializer < ActiveModel::Serializer
  attributes :about, :faq, :privacy_policy, :terms_and_conditions, :sharing_url, :graceful_error_message, :logo_url,
             :app_tour_messages, :supported_currencies
end