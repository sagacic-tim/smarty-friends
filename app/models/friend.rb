# Gem Requirements
require "smartystreets_ruby_sdk/client_builder"
require "smartystreets_ruby_sdk/static_credentials"
require "smartystreets_ruby_sdk/us_street/lookup"
require 'bigdecimal'
require 'dry-types'
require 'dry-struct'
require 'dry-validation'
require 'email_validator'
require 'phonelib'
require 'date'

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

class DateConstrainedType < Dry::Types::Definition
  DATE_FORMATS = [
    '%Y-%m-%d', '%m/%d/%Y', '%d/%m/%Y', '%Y/%m/%d',
    '%m-%d-%Y', '%d-%m-%Y', '%Y-%m-%d', '%Y%m%d',
    '%B %d, %Y', '%Y %B %d'
  ].freeze

  def initialize(type = Dry::Types['strict.string'])
    super(type.constructor(&method(:parse_date)))
  end

  private

  def parse_date(value)
    DATE_FORMATS.each do |format|
      parsed_date = Date.strptime(value, format) rescue nil
      return parsed_date.strftime('%m/%d/%Y') if parsed_date
    end

    raise Dry::Types::CoercionError.new("Invalid date format: #{value}")
  end
end

class Friend < ApplicationRecord
  # Add association for Friendattribute(s
  has_many :friend_attributes
  include ValidationPredicates

  # Before updating the ActiveRecord record, call the SmartyStreets
  # API to validate the address.
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
      puts "At least one candidate returned.\n\nMatch parameter\
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

    # Update the address and geolocation attribute(s based on the returned candidate's components
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
end

class FriendAttributes < Dry::Struct
  # defining all the data structures to be used in the app.
  # This is just for the purpose of introducing dry-types in
  # ruby development. This is not neccesarily the best way to
  # implemention of dry-types, but rather a first attempt at
  # using it.
  require 'dry-types'
  require 'dry-struct'

  module Types
    include Dry.Types()
  end

  # define all the possible parts of a person's name
  name_fields = Types::Hash.schema(
    name_title: Types::Coercible::String.optional.constrained(max_size: 8),
    name_first: Types::Coercible::String.constrained(max_size: 32),
    name_middle: Types::Coercible::String.optional.constrained(max_size: 32),
    name_last: Types::Coercible::String.constrained(max_size: 32),
    name_suffix: Types::Coercible::String.optional.constrained(max_size: 8)
  ).strict

  # define the contact information desired to be collected
  contact_info_fields = Types::Hash.schema(
    email_1: Types::String.constrained(format: URI::MailTo::EMAIL_REGEXP),
    email_2: Types::Nil | Types::String.constrained(format: URI::MailTo::EMAIL_REGEXP),
    phone_1: Types::String.constrained(max_size: 20),
    phone_2: Types::Nil | Types::String.constrained(max_size: 20),
    twitter_handle: String
  ).strict

  DateConstrainedType = DateConstrainedType.new()
  DemographicsFields = Types::Hash.schema(
    dob: Types::Coercible::String.constrained(format: DateConstrainedType).optional,
    sex: Types::String.constrained(max_size: 6).optional,
    occupation: Types::String.constrained(max_size: 32).optional,
    available_to_party: Types::Bool
  ).strict

  address_fields = Types::Hash.schema(
    delivery_line_1: Types::String.constrained(max_size: 50),
    last_line: Types::String.constrained(max_size: 50),
    street_number: Types::String.constrained(max_size: 30),
    street_predirection: Types::String.constrained(max_size: 16).optional,
    street_name: Types::String.constrained(max_size: 64),
    street_suffix: Types::String.constrained(max_size: 16),
    street_postdirection: Types::String.constrained(max_size: 16).optional,
    city: Types::String.constrained(max_size: 64),
    state_abbreviation: Types::String.constrained(max_size: 2),
    country: Types::String.default('United States').constrained(max_size: 32).optional,
    country_code: Types::String.default('US').constrained(max_size: 4),
    postal_code: Types::String.constrained(max_size: 5),
    zip_plus_4_extension: Types::String.constrained(max_size: 4).optional
  ).strict

  LatitudeType = Types::Decimal.constrained(gteq: BigDecimal('-90'), lteq: BigDecimal('90'))
  LongitudeType = Types::Decimal.constrained(gteq: BigDecimal('-180'), lteq: BigDecimal('180'))

  geolocation_fields = Types::Hash.schema(
    latitude: LatitudeType,
    longitude: LongitudeType,
    lat_long_location_precision: Types::String.constrained(max_size: 18)
  )
end