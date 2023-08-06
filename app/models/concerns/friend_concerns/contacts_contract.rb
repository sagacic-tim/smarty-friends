require_relative 'friend_types/email_type'
require_relative 'friend_types/phone_number_type'
require_relative 'friend_types/twitter_handle_type'
require 'dry-types'
require 'dry-validation'

# define the contact information desired to be collected
class ContactsContract < Dry::Validation::Contract
  params do
    required(:email_1).filled(Types::EmailType)
    optional(:email_2).filled(Types::Nil | Types::EmailType)
    optional(:phone_1).filled(Types::PhoneNumberType)
    optional(:phone_2).filled(Types::Nil | Types::PhoneNumberType)
    optional(:twitter_handle).filled(Types::Nil | Types::TwitterHandleType)
  end
end