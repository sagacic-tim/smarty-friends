require 'dry-types'
require 'dry-logic'
require 'bigdecimal'

module Types
  include Dry.Types()

  LongitudeType = Types::Coercible::Decimal.constrained(gteq: BigDecimal('-180'), lteq: BigDecimal('180')).constructor do |value|
    parsed_value = Types::Coercible::Decimal[value]
    raise Dry::Types::ConstraintError.new("Invalid longitude: #{value}") unless (-180..180).cover?(parsed_value)
    parsed_value
  end
end