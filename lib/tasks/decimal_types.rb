module Dry
    module Types
      include Dry.Types()
      Decimal = ::Types::Coercible::Decimal
    end
end  