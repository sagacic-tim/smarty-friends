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
require 'date'

module Types
  include Dry.Types()
end

class DateConstrainedType
  DATE_FORMATS = [
    '%Y-%m-%d', '%m/%d/%Y', '%d/%m/%Y', '%Y/%m/%d',
    '%m-%d-%Y', '%d-%m-%Y', '%Y-%m-%d', '%Y%m%d',
    '%B %d, %Y', '%Y %B %d'
  ].freeze

  def self.call(value)
    parse_date(value)
  end

  private_class_method def self.parse_date(value)
    DATE_FORMATS.each do |format|
      begin
        parsed_date = Date.strptime(value, format)
        return parsed_date.strftime('%d/%m/%Y')
      rescue ArgumentError
        next
      end
    end

    raise Dry::Types::CoercionError.new("Invalid date format: #{value}")
  end
end

module ValidationPredicates
  include Dry::Logic::Predicates

  def valid_email?(value)
    email_validator = EmailValidator.new(value)
    email_validator.valid? && email_validator.valid_local?
  end

  def phone_format?(value)
    parsed_number = Phonelib.parse(value)
    parsed_number.valid?
  end

  def valid_twitter_handle?(value)
    EmailValidator.valid?(value, EmailValidator::REGEX::TWITTER_HANDLE)
  end
end

class Friend < ApplicationRecord
  # app/models/friend.rb – This is a placeholder class that is
  # populated with data from Dry::Struct class FriendService
end

class FriendAttributes < Dry::Struct
  # defining all hte data structures to be used in the app.
  # This is just for the purpose of introducing dry-types in
  # ruby development. This is not neccesarily the best way to
  # implemention of dry-types, but rather a first attempt at
  # using it.
  include Types

  # define all the possible parts of a person's name
  attribute :name_hash, Types::Hash.schema(
    name_title: Coercible::String.optional.constrained(max_size: 32),
    name_first: Coercible::String.constrained(max_size: 32),
    name_middle: Coercible::String.optional.constrained(max_size: 32),
    name_last: Coercible::String.constrained(max_size: 32),
    name_suffix: Coercible::String.optional.constrained(max_size: 32)
  ).strict

  # define the contact information desired to be collected

  attribute :contact_info_hash, Types::Hash.schema(
    email_1: String.constrained(format: URI::MailTo::EMAIL_REGEXP),
    email_2: String.optional.constrained(format: URI::MailTo::EMAIL_REGEXP),
    phone_1: String.constrained(phone_format: :phone_number),
    phone_2: String.optional.constrained(phone_format: :phone_number),
    twitter_handle: String.optional.constrained(max_size: 32)
  ).strict

  dob_type = DateConstrainedType.new
  attribute demographics_hash: Types::Hash.schema(
    dob: Coercible::String.optional.constrained(format: dob_type),
    sex: String.optional.constrained(max_size: 6),
    occupation: String.optional.constrained(max_size: 32),
    available_to_party: Types::Bool
  )

  attribute :address_hash, Types::Hash.schema(
    delivery_line_1: String.constrained(max_size: 50),
    last_line: String.constrained(max_size: 50),
    street_number: String.constrained(max_size: 30),
    street_predirection: String.optional.constrained(max_size: 16),
    street_name: String.constrained(max_size: 64),
    street_suffix: String.constrained(max_size: 16),
    street_postdirection: String.optional.constrained(max_size: 16),
    city: String.constrained(max_size: 64),
    county: String.optional.constrained(max_size: 64),
    state_abbreviation: String.constrained(max_size: 2),
    country: String.optional.default('United States').constrained(max_size: 32),
    country_code: String.default('US').constrained(max_size: 4),
    postal_code: String.constrained(max_size: 5),
    zip_plus_4_extension: String.optional.constrained(max_size: 4)
  )

  LatitudeType = Decimal.optional.constrained(gteq: BigDecimal('-90'), lteq: BigDecimal('90'))
  LongitudeType = Decimal.optional.constrained(gteq: BigDecimal('-180'), lteq: BigDecimal('180'))

  attribute :geolocation_hash, Types::Hash.schema(
    latitude: LatitudeType,
    longitude: LongitudeType,
    lat_long_location_precision: String.optional.constrained(max_size: 18)
  )
end

# method to convert the FriendAttributes object, from Dry::Struct
# class attributes to Friend ApplicationRecord fields class, to make the
# connection to database
class FriendService
  def self.create_friend(friend_data)
    # Create the Friend instance
    Friend.create!(friend_data.to_h)
  end
end

# Before updating the ActiveRecord record, call the SmartyStreets API to validate the address.
before_update :validate_address_with_smartystreets

def validate_address_with_smartystreets
  address_string = "#{address_hash['street_number']} #{address_hash['street_predirection']} #{address_hash['street_name']} #{address_hash['street_suffix']}, #{address_hash['city']} #{address_hash['state_abbreviation']} #{address_hash['postal_code']}"

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
    puts = "At least one candidate returned.\n\nMatch parameter\
      is set to #{lookup.match}, The API will return detailed output\ 
      only if a valid match is found. Otherwise, the API response will\
      be an empty array."
  when :enhanced
    puts "At least one candidate returned.\n\nMatch parameter is set\
      to #{lookup.match}, The API will return detailed output based on\
      a more aggressive matching mechanism. It also includes a more com-\
      prehensive address dataset beyond just the postal address data.\
      Requires a US Core license or a US Rooftop Geocoding license. Note:\
      A freeform address, that we can't find a match for, will respond\
      with an empty array, \"\[\]\"."
  when :invalid
    puts "Many candidates are possible matches.\n\nMatch parameter is\
      set to #{lookup.match}, The API will return detailed output for\
      both valid and invalid addresses. To find out if the address is\
      valid, check the dpv_match_code. Values of Y, S, or D indicate a\
      valid address."
  else
    puts "No known match type"
  end

  # Update the address and geolocation attributes based on the returned candidate's components
  address_hash['last_line'] = first_candidate.components.last_line
  address_hash['delivery_line_1'] = first_candidate.components.delivery_line_1
  address_hash['street_number'] = first_candidate.components.primary_number
  address_hash['street_predirection'] = first_candidate.components.primary_number
  address_hash['street_name'] = first_candidate.components.street_name
  address_hash['street_suffix'] = first_candidate.components.street_suffix
  address_hash['street_postdirection'] = first_candidate.components.street_postdirection
  address_hash['city'] = first_candidate.components.city_name
  address_hash['county'] = first_candidate.metadata.county_name
  address_hash['state_abbreviation'] = first_candidate.components.state_abbreviation
  address_hash['postal_code'] = first_candidate.components.zipcode
  address_hash['zip_plus_4_extension'] = first_candidate.components.plus4_code

  geolocation_hash['latitude'] = first_candidate.components.latitude
  geolocation_hash['longitude'] = first_candidate.components.longitude
  geolocation_hash['lat_long_location_precision'] = first_candidate.components.precision
end
