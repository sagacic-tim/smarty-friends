require 'dry-types'
require 'dry-types'
require 'dry-logic'
require 'phonelib'

module Types
  include Dry.Types()

  PhoneNumberType = Types::String.constructor do |value|
    # Use phonelib's parse method to validate and parse the phone number
    parsed_number = Phonelib.parse(value)
    
    # Check if the number is valid and raise an error if it's not
    raise Dry::Types::ConstraintError, 'Invalid phone number' unless parsed_number.valid?
    
    # Return the E.164 formatted phone number
    parsed_number.full_e164
  end
end