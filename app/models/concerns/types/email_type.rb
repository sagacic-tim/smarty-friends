require 'dry-types'
require 'email_validator'

module Types
  include Dry.Types()

  EmailType = Types::String.constrained(format: EmailValidator::REGEX) do |value|
    raise Dry::Types::ConstraintError, "#{value.inspect} is not a valid email address." unless EMAIL_REGEX.match?(value)
    value
  end
end