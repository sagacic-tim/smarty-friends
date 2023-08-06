require 'dry-types'

module Types
  include Dry.Types()

  TwitterHandleType = Types::String.constructor do |value|
    TWITTER_HANDLE_REGEX = /^(@)?[a-zA-Z0-9_]{1,15}$/

    unless TWITTER_HANDLE_REGEX.match?(value)
      raise Dry::Types::ConstraintError, "#{value.inspect} is not a valid Twitter handle."
    end

    value
  end
end