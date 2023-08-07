require 'dry-types'
require 'dry-logic'
require 'dry-validation'
require 'email_validator'

module Types
  include Dry.Types()

  EmailType = Types::String.constrained(format: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/) do |value|
    raise Dry::Types::ConstraintError, "#{value.inspect} is not a valid email address." unless EmailValidator.valid?(value)
    value
  end
end
