require 'dry-types'
require 'dry-logic'
require 'bigdecimal'

module Types
  include Dry.Types()

  LatitudeType = Types::Coercible::Decimal.constrained(gteq: BigDecimal('-90'), lteq: BigDecimal('90')).constructor do |value|
    parsed_value = Types::Coercible::Decimal[value]
    raise Dry::Types::ConstraintError.new("Invalid latitude: #{value}") unless (-90..90).cover?(parsed_value)
    parsed_value
  end
end