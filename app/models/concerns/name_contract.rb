require_relative 'types/name_title_type'
require_relative 'types/name_suffix_type'
require 'dry-types'
require 'dry-validation'

# Create a name contract that allows for storage of all parts of a name.
class NameContract < Dry::Validation::Contract
  params do
    optional(:name_title).filled(Types::NameTitleType)
    required(:name_first).filled(Types::Coercible::String.constrained(max_size: 32))
    optional(:name_middle).filled(Types::Coercible::String.optional.constrained(max_size: 32))
    required(:name_last).filled(Types::Coercible::String.constrained(max_size: 32))
    optional(:name_suffix).filled(Types::NameSuffixType)
  end
end