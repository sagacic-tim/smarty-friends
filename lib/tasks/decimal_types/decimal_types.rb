module DecimalTypes
    include Dry.Types()
    Decimal = Types::Coercible::Decimal
    String = Types::Coercible::String
    DecimalToString = ::Types::Coercible::Decimal.constructor(&:to_s)
end
  