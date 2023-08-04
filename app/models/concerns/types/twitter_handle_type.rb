require 'dry-types'

module Types
  include Dry.Types()

  class TwitterHandleType < Dry::Types::Value
    TWITTER_HANDLE_REGEX = /^(@)?[a-zA-Z0-9_]{1,15}$/

    def self.valid?(value)
      TWITTER_HANDLE_REGEX.match?(value)
    end

    def self.error_message(value)
      "#{value.inspect} is not a valid Twitter handle."
    end
  end
end