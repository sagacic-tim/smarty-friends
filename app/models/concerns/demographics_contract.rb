require_relative 'types/all_dates_to_us_date'
require 'dry-types'
require 'dry-validation'

# define the contact information desired to be collected
class DemographicsContract < Dry::Validation::Contract
  params do
    optional(:dob).filled(Types::AllDatesToUSDate)
    optional(:sex).filled(Types::String.constrained(max_size: 6))
    optional(:occupation).filled(Types::String.constrained(max_size: 32))
    optional(:available_to_party).filled(Types::Bool)
  end
end