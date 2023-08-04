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
module Types
  include Dry.Types()

  Email = String.constrained(format: EmailValidator::REGEX)

  PhoneNumber = Types::String.constructor do |value|
    # Use phonelib's parse method to validate and parse the phone number
    parsed_number = Phonelib.parse(value)
    
    # Check if the number is valid and raise an error if it's not
    raise Dry::Types::ConstraintError, 'Invalid phone number' unless parsed_number.valid?
    
    # Return the E.164 formatted phone number
    parsed_number.full_e164
  end

  class TwitterHandle < Dry::Types::Value
    TWITTER_HANDLE_REGEX = /^(@)?[a-zA-Z0-9_]{1,15}$/

    def self.valid?(value)
      TWITTER_HANDLE_REGEX.match?(value)
    end

    def self.error_message(value)
      "#{value.inspect} is not a valid Twitter handle."
    end
  end
  
  class DateConstrainedType < Dry::Types::Definition
    DATE_FORMATS = [
      '%Y-%m-%d', '%m/%d/%Y', '%d/%m/%Y', '%Y/%m/%d',
      '%m-%d-%Y', '%d-%m-%Y', '%Y-%m-%d', '%Y%m%d',
      '%B %d, %Y', '%Y %B %d'
    ].freeze

    def initialize(type = Dry::Types['strict.string'])
      super(type.constructor(&method(:parse_date)).constrained(&method(:validate_date)))
    end

    private

    def parse_date(value)
      DATE_FORMATS.each do |format|
        parsed_date = Date.strptime(value, format) rescue nil
        return parsed_date.strftime('%m/%d/%Y') if parsed_date
      end

      raise Dry::Types::CoercionError.new("Invalid date format: #{value}")
    end

    def validate_date(value)
      return value if parse_date(value) # Check if the date can be parsed successfully
      raise Dry::Types::ConstraintError.new("Invalid date: #{value}")
    end
  end

  Latitude = Types::Decimal.constrained(gteq: BigDecimal('-90'), lteq: BigDecimal('90'))
  Longitude = Types::Decimal.constrained(gteq: BigDecimal('-180'), lteq: BigDecimal('180'))

  NameTitle = Strict::String.enum('Adm.', 'Amb.', 'Baron', 'Brnss.', 'Bishop', 'Brig. Gen.', 'Br.', 'Cpt.', 'Capt.', 'Chan.', 'Chapln.', 'CPO', 'Cmdr.', 'Col.', 'Col. (Ret.)', 'Cpl.', 'Count', 'Countess', 'Dean', 'Dr.', 'Duke', 'Ens.', 'Fr.', 'Frau', 'Gen.', 'Gov.', 'Judge', 'Justice', 'Lord', 'Lt.', '2Lt.', '2dLt.', 'Lt. Cmdr.', 'Lt. Col.', 'Lt. Gen.', 'Lt. j.g.', 'Mlle.', 'Maj.', 'Master', 'Master Sgt.', 'Miss', 'Mme.', 'MIDN', 'M.', 'Msgr.', 'Mr.', 'Mrs.', 'Ms.', 'Mx.', 'Pres.', 'Princess', 'Prof.', 'Rabbi', 'R.Adm.', 'Rep.', 'Rev.', 'Rt.Rev.', 'Sgt.', 'Sen.', 'Sr.', 'Sra.', 'Srta.', 'Sheikh', 'Sir', 'Sr.', 'S. Sgt.', 'The Hon.', 'The Venerable', 'V.Adm.')
  NameSuffix = Strict::String.enum('B.A.', 'B.F.A.', 'B.M.', 'B.S.', 'B.S.E.E.', 'D.A.', 'D.B.A.', 'D.D.S.', 'D.M.L.', 'D.Min.','D.P.T.', 'Ed.D.', 'Ed.M.', 'J.D.', 'M.A.', 'M.B.A.', 'M.Div.', 'M.F.A.', 'M.D.', 'M.M.', 'M.P.A.', 'M.Phil.', 'M.S.', 'M.S.A.', 'M.S.E.E.', 'M.S.L.I.S.', 'M.S.P.T.', 'M.Th.', 'Ph.D.', 'R.N.', 'S.T.M.', 'Th.D.')
end

class Friend < ApplicationRecord
end

class Name < Dry::Validation::Contract
  params do
  optional(:name_title).filled(Types::NameTitle)
  optional(:name_first).filled(Types::Coercible::String.constrained(max_size: 32))
  optional(:name_middle).filled(Types::Coercible::String.optional.constrained(max_size: 32))
  optional(:name_last).filled(Types::Coercible::String.constrained(max_size: 32))
  optional(:name_suffix).filled(Types::NameSuffix)
  end
end

  # define the contact information desired to be collected
  contact_info_fields = Types::Hash.schema(
    email_1: Types::Email,
    email_2: Types::Nil | Types::Email,
    phone_1: Types::PhoneNumber,
    phone_2: Types::Nil | Types::PhoneNumber,
    twitter_handle: Types::TwitterHandle
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

  geolocation_fields = Types::Hash.schema(
    latitude: Types::Latitude,
    longitude: Types::Longitude,
    lat_long_location_precision: Types::String.constrained(max_size: 18)
  )
end