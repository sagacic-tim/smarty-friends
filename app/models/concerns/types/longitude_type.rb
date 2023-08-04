require 'bigdecimal'
require 'dry-types'

module Types
  include Dry.Types()

  class LongitudeType < Dry::Types::Definition
    LONGITUDE_MIN = BigDecimal('-180')
    LONGITUDE_MAX = BigDecimal('180')

    def initialize(type = Types::Decimal)
      super(type.constrained(gteq: LONGITUDE_MIN, lteq: LONGITUDE_MAX, message: "LONGitude must be between #{LONGITUDE_MIN} and #{LONGITUDE_MAX}"))
    end
  end
end