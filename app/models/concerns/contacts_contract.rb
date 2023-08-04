require_relative 'types/email_type'
require_relative 'types/phone_number_type'
require_relative 'types/twitter_handle_type'
require 'dry-types'
require 'dry-validation'

# define the contact information desired to be collected
class ContactsContract < Dry::Validation::Contract
  params do
    required(:email_1).filled(Types::Email)
    optional(:email_2).filled(Types::Nil | Types::Email)
    optional(:phone_1).filled(Types::PhoneNumber)
    optional(:phone_2).filled(Types::Nil | Types::PhoneNumber)
    optional(:twitter_handle).filled(Types::Nil | Types::TwitterHandle)
  end
end