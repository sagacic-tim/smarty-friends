require "smartystreets_ruby_sdk/client_builder"
require "smartystreets_ruby_sdk/static_credentials"
require "smartystreets_ruby_sdk/us_street/lookup"
require "smartystreets_ruby_sdk/us_street/match_type"
require 'bigdecimal'
require 'dry-types'
require 'dry-struct'
require 'dry-validation'
require 'email_validator'
require 'phonelib'

module Types
  include Dry.Types()
end

module ValidationPredicates
  include Dry::Logic::Predicates

  def valid_email?(value)
    email_validator = EmailValidator.new(value)
    email_validator.valid? && email_validator.valid_local?
  end

  def valid_phone_number?(value)
    parsed_number = Phonelib.parse(value)
    parsed_number.valid?
  end

  def valid_twitter_handle?(value)
    EmailValidator.valid?(value, EmailValidator::REGEX::TWITTER_HANDLE)
  end
end

class Friend < Dry::Struct
  attribute :name_hash, Types::Hash.schema(
    name_title: Types::Coercible::String.optional.constrained(max_size: 8),
    name_first: Types::Coercible::String.constrained(max_size: 32),
    name_middle: Types::Coercible::String.optional.constrained(max_size: 32),
    name_last: Types::Coercible::String.constrained(max_size: 32),
    name_suffix: Types::Coercible::String.optional.constrained(max_size: 8)
  ).default(Hash.new).strict

  attribute :contact_info_hash, Types::Hash.schema(
    email_1: Types::String.constrained(format: URI::MailTo::EMAIL_REGEXP),
    email_2: Types::Nil | Types::String.constrained(format: URI::MailTo::EMAIL_REGEXP),
    phone_1: Types::String.constrained(phone_format: :phone_number),
    phone_2: Types::Nil | Types::String.constrained(phone_format: :phone_number),
    twitter_handle: Types::String
  ).default(Hash.new).strict

  attribute :demographics_hash, Types::Hash.schema(
    dob: Types::Date.constrained(min: Date.new(1880, 1, 1), max: Date.today - 18 * 365),
    sex: Types::String.constrained(max_size: 6).optional,
    occupation: Types::String.constrained(max_size: 32).optional,
    available_to_party: Types::Boolean
  ).default(Hash.new).strict

  attribute :address_hash, Types::Hash.schema(
    street_number: Types::String.constrained(max_size: 30),
    street_predirection: Types::String.constrained(max_size: 16).optional,
    street_name: Types::String.constrained(max_size: 64),
    street_suffix: Types::String.constrained(max_size: 16),
    street_postdirection: Types::String.constrained(max_size: 16).optional,
    city: Types::String.constrained(max_size: 64),
    county: Types::String.constrained(max_size: 64).optional,
    state_abbreviation: Types::String.constrained(max_size: 2),
    country: Types::String.constrained(max_size: 32).optional,
    country_code: Types::String.constrained(max_size: 4),
    postal_code: Types::String.constrained(max_size: 5),
    zip_plus_4_extension: Types::String.constrained(max_size: 4).optional
  ).default(Hash.new).strict

  LatitudeType = Types::Decimal.constrained(gteq: BigDecimal('-90'), lteq: BigDecimal('90'))
  LongitudeType = Types::Decimal.constrained(gteq: BigDecimal('-180'), lteq: BigDecimal('180'))

  attribute :geolocation_hash, Types::Hash.schema(
    latitude: LatitudeType,
    longitude: LongitudeType,
    lat_long_location_precision: Types::String
  )
end

FriendSchema = Dry::Validation.Params do
  configure do
    predicates(ValidationPredicates)
  end
  
  required(:name_hash).value(:hash) do
    required(:name_first).filled(:string)
    required(:name_last).filled(:string)
    optional(:name_title).maybe(:string)
    optional(:name_middle).maybe(:string)
    optional(:name_suffix).maybe(:string)
  end

  required(:contact_info_hash).value(:hash) do
    required(:email_1).filled(:string) do
      rule(email_format: [:email, :valid_email?])
    end

    optional(:email_2).maybe(:string) do
      rule(email_format: [:email, :valid_email?])
    end

    optional(:phone_1).maybe(:string) do
      rule(phone_format: :valid_phone_number?)
    end

    optional(:phone_2).maybe(:string) do
      rule(phone_format: :valid_phone_number?)
    end

    optional(:twitter_handle).maybe(:string) do
      rule(twitter_handle_format: :valid_twitter_handle?)
    end
  end
  required(:demographics_hash).value(:hash) do
    optional(:dob).maybe(:date)
    optional(:sex).maybe(:string)
    optional(:occupation).maybe(:string)
    required(:available_to_party).filled(:boolean)
  end
  required(:address_hash).value(:hash) do
    required(:street_number).filled(:string)
    optional(:street_predirection).maybe(:string)
    required(:street_name).filled(:string)
    required(:street_suffix).filled(:string)
    optional(:street_postdirection).maybe(:string)
    required(:city).filled(:string)
    optional(:county).maybe(:string)
    required(:state_abbreviation).filled(:string)
    required(:country_code).filled(:string)
    required(:postal_code).filled(:string)
    optional(:zip_plus_4_extension).maybe(:string)
  end
  optional(:geolocation_hash).value(:hash) do
      optional(:latitude).maybe(:decimal)
      optional(:longitude).matbe(:decimakl)
      optional(:precision).maybe(:string)
  end
end

# app/models/friend_record.rb – This is a dummy class that is
# populated with data from Dry::Struct class FrinedService
class FriendRecord < ApplicationRecord
end

# method to convert the Friend object, from Dry::Struct class,
# to FriendRecord, the ActiveRecord class, and save it to the database:
class FriendService
  def self.create_friend(friend_data)
    # Fetch the data from the hash attributes into temporary variables
    name_data = friend_data[:name_hash] || {}
    contact_info_data = friend_data[:contact_info_hash] || {}
    demographics_data = friend_data[:demographics_hash] || {}
    address_data = friend_data[:address_hash] || {}
    geolocation_data = friend_data[:geolocation_hash] || {}

    # Combine all data into a single hash for creating the FriendRecord instance
    friend_record_data = {
      name_title: name_data['name_title'],
      name_first: name_data['name_first'],
      name_middle: name_data['name_middle'],
      name_last: name_data['name_last'],
      name_suffix: name_data['name_suffix'],
      email_1: contact_info_data['email_1'],
      email_2: contact_info_data['email_2'],
      phone_1: contact_info_data['phone_1'],
      phone_2: contact_info_data['phone_2'],
      twitter_handle: contact_info_data['twitter_handle'],
      dob: demographics_data['dob'],
      sex: demographics_data['sex'],
      occupation: demographics_data['occupation'],
      available_to_party: demographics_data['available_to_party'],
      street_number: address_data['street_number'],
      street_predirection: address_data['street_predirection'],
      street_name: address_data['street_name'],
      street_suffix: address_data['street_suffix'],
      street_postdirection: address_data['street_postdirection'],
      city: address_data['city'],
      county: address_data['county'],
      state_abbreviation: address_data['state_abbreviation'],
      country_code: address_data['country_code'],
      postal_code: address_data['postal_code'],
      zip_plus_4_extension: address_data['zip_plus_4_extension'],
      latitude: geolocation_data['latitude'],
      longitude: geolocation_data['longitude'],
      lat_long_location_precision: geolocation_data['lat_long_location_precision']
    }

    # Create the FriendRecord instance
    friend_record = FriendRecord.create!(friend_record_data)

    friend_record
  end
end

# Before updating the ActiveRecord record, call the SmartyStreets API to validate the address.
before_update :validate_address_with_smartystreets

def validate_address_with_smartystreets
  address_hash = self.address

  address_string = "#{address_hash['street_number']} #{address_hash['street_name']} #{address_hash['street_suffix']}, #{address_hash['city']} #{address_hash['state_abbreviation']} #{address_hash['postal_code']}"

  # Call SmartyStreets API to validate the address
  app_auth_id = Rails.application.credentials.dig(:smarty_streets, :auth_id)
  app_auth_token = Rails.application.credentials.dig(:smarty_streets, :auth_token)
  credentials = SmartyStreets::StaticCredentials.new(app_auth_id, app_auth_token)
  client = SmartyStreets::ClientBuilder.new(credentials).build_us_street_api_client
  lookup = SmartyStreets::USStreet::Lookup.new(address_string) # Pass the address string as an argument
  lookup.match = :strict # Indicates an exact address match.

  begin
    client.send_lookup(lookup)
  rescue SmartyStreets::SmartyError => err
    puts err
    return
  end

  result = lookup.result

  if result.empty?
    puts 'No candidates. This means the address is not valid.'
    return
  end

  first_candidate = result[0]

  case lookup.match
  when :strict
    puts "At least one candidate returned.\n\nMatch parameter is set to #{lookup.match}, The API will return detailed output only if a valid match is found. Otherwise, the API response will be an empty array."
  when :enhanced
    puts "At least one candidate returned.\n\nMatch parameter is set to #{lookup.match}, The API will return detailed output based on a more aggressive matching mechanism. It also includes a more comprehensive address dataset beyond just the postal address data. Requires a US Core license or a US Rooftop Geocoding license. Note: A freeform address, that we can't find a match for, will respond with an empty array, \"\[\]\"."
  when :invalid
    puts "Many candidates are possible matches.\n\nMatch parameter is set to #{lookup.match}, The API will return detailed output for both valid and invalid addresses. To find out if the address is valid, check the dpv_match_code. Values of Y, S, or D indicate a valid address."
  else
    puts "Invalid match type"
  end

  # Update the address and geolocation attributes based on the returned candidate's components
  address_hash["street_number"] = first_candidate.components.primary_number
  address_hash["street_predirection"] = first_candidate.components.primary_number
  address_hash["street_name"] = first_candidate.components.street_name
  address_hash["street_suffix"] = first_candidate.components.street_suffix
  address_hash["street_postdirection"] = first_candidate.components.street_postdirection
  address_hash["city"] = first_candidate.components.city_name
  address_hash["county"] = first_candidate.metadata.county_name
  address_hash["state_abbreviation"] = first_candidate.components.state_abbreviation
  address_hash["postal_code"] = first_candidate.components.zipcode
  address_hash["zip_plus_4_extension"] = first_candidate.components.plus4_code

  geolocation_hash["latitude"] = first_candidate.components.latitude
  geolocation_hash["longitude"] = first_candidate.components.longitude
  geolocation_hash["lat_long_location_precision"] = first_candidate.components.precision
end