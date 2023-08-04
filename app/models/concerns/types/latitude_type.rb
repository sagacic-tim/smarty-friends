require 'dry-types'
require 'bigdecimal'

module Types
  include Dry.Types()

  class LatitudeType < Dry::Types::Definition
    LATITUDE_MIN = BigDecimal('-90')
    LATITUDE_MAX = BigDecimal('90')

    def initialize(type = Types::Decimal)
      super(type.constrained(gteq: LATITUDE_MIN, lteq: LATITUDE_MAX, message: "Latitude must be between #{LATITUDE_MIN} and #{LATITUDE_MAX}"))
    end
  end
end