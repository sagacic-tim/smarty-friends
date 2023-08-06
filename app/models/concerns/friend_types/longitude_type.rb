require 'bigdecimal'
require 'dry-types'

module Types
  include Dry.Types()

  class LongitudeType < Dry::Types::Definition
    LONGITUDE_MIN = BigDecimal('-180')
    LONGITUDE_MAX = BigDecimal('180')

    def self.constrained_type
      Types::Decimal.constrained(gteq: LONGITUDE_MIN, lteq: LONGITUDE_MAX, message: "Longitude must be between #{LONGITUDE_MIN} and #{LONGITUDE_MAX}")
    end
  end
end