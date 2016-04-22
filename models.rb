class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  field :email, type: String
  field :name, type: String
  field :given_name, type: String
  field :family_name, type: String
  field :user_id, type: String
  embeds_many :transactions
  embeds_many :accounts
  has_many :issues
end

class Transaction
  include Mongoid::Document

  field :receiver, type: String
  field :amount, type: BigDecimal
  field :sent_at, type: DateTime, default: -> { Time.now }
  field :received_at, type: DateTime
  field :token, type: String
  field :payment_details, type: Hash
  field :partial, type: Boolean
  field :completed, type: Boolean, default: false
  field :cap_reached, type: Boolean
  field :duplicate_receiver, type: Boolean
  field :refunded, type: Boolean, default: false
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

class Issue
  include Mongoid::Document

  field :type, type: String
  field :message, type: String
  field :email, type: String
  field :created_at, type: DateTime, default: -> { Time.now }
  field :resolved, type: Boolean, default: false
  belongs_to :user
end

class GlobalPrefs
  include Mongoid::Document
  # todo define more fields here as needed
  field :about, type: String
  field :faq, type: String
  field :privacy_policy, type: String
  field :terms_and_conditions, type: String
  field :sharing_url, type: String
  field :graceful_error_message, type: String
  field :logo_url, type: String
  field :app_tour_messages, type: Hash
  field :supported_currencies, type: Array

  field :exchange_rates, type: Hash
  #src: http://stackoverflow.com/questions/7120855/block-the-creation-of-multiple-object-of-a-class
  before_validation(:ensure_has_only_one_record, :on => :create)

  def ensure_has_only_one_record
    self.errors.add :base, 'There can only be one GlobalPrefs instance.' if GlobalPrefs.all.count > 0
  end
end