require 'dry-types'
require 'bigdecimal'

module Types
  include Dry.Types()

  class LatitudeType < Dry::Types::Nominal
    LATITUDE_MIN = BigDecimal('-90')
    LATITUDE_MAX = BigDecimal('90')

    def initialize(type = Types::Coercible::Decimal)
      super(constrained(type, gteq: LATITUDE_MIN, lteq: LATITUDE_MAX).constructor(&method(:parse_latitude)))
    end

    private

    def parse_latitude(value)
      parsed_value = Types::Coercible::Decimal[value]
      raise Dry::Types::ConstraintError.new("Invalid latitude: #{value}") unless (LATITUDE_MIN..LATITUDE_MAX).cover?(parsed_value)
      parsed_value
    end
  end
end

