require_relative 'friend_types/latitude_type'
require_relative 'friend_types/longitude_type'
require 'dry-types'
require 'dry-validation'

class GeolocationContract < Dry::Validation::Contract
  params do
    optional(:latitude).filled(Types::Nil | Types::Latitude)
    optional(:longitude).filled(Types::Nil | Types::Longitude)
    optional(:lat_long_location_precision).filled(Types::Nil | Types::String.constrained(max_size: 18))
  end
end