require 'dry-types'
require 'dry-validation'

class AddressContract < Dry::Validation::Contract
  params do
    optional(:delivery_line_1).filled(Types::String.constrained(max_size: 50))
    optional(:last_line).filled(Types::String.constrained(max_size: 50))
    required(:street_number).filled(Types::String.constrained(max_size: 30))
    optional(:street_predirection).filled(Types::String.constrained(max_size: 16))
    required(:street_name).filled(Types::String.constrained(max_size: 64))
    required(:street_suffix).filled(Types::String.constrained(max_size: 16))
    optional(:street_postdirection).filled(Types::String.constrained(max_size: 16))
    required(:city).filled(Types::String.constrained(max_size: 64))
    required(:state_abbreviation).filled(Types::String.constrained(max_size: 2))
    optional(:country).filled(Types::String.default('United States').constrained(max_size: 32))
    optional(:country_code).filled(Types::String.default('US').constrained(max_size: 4))
    required(:postal_code).filled(Types::String.constrained(max_size: 5))
    optional(:zip_plus_4_extension).filled(Types::String.constrained(max_size: 4))
  end
end