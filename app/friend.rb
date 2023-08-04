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

  Email = Types::String.constrained(format: EmailValidator::REGEX) do |value|
    raise Dry::Types::ConstraintError, "#{value.inspect} is not a valid email address." unless EMAIL_REGEX.match?(value)
    value
  end

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
  
  class AllDatesToUSDate < Dry::Types::Definition
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

  class Latitude < Dry::Types::Definition
    LATITUDE_MIN = BigDecimal('-90')
    LATITUDE_MAX = BigDecimal('90')

    def initialize(type = Types::Decimal)
      super(type.constrained(gteq: LATITUDE_MIN, lteq: LATITUDE_MAX, message: "Latitude must be between #{LATITUDE_MIN} and #{LATITUDE_MAX}"))
    end
  end

  class Longitude < Dry::Types::Definition
    LONGITUDE_MIN = BigDecimal('-180')
    LONGITUDE_MAX = BigDecimal('180')

    def initialize(type = Types::Decimal)
      super(type.constrained(gteq: LONGITUDE_MIN, lteq: LONGITUDE_MAX, message: "LONGitude must be between #{LONGITUDE_MIN} and #{LONGITUDE_MAX}"))
    end
  end
  Longitude = Types::Decimal.constrained(gteq: BigDecimal('-180'), lteq: BigDecimal('180'))

  NameTitle = Strict::String.enum('Adm.', 'Amb.', 'Baron', 'Brnss.', 'Bishop', 'Brig. Gen.', 'Br.', 'Cpt.', 'Capt.', 'Chan.', 'Chapln.', 'CPO', 'Cmdr.', 'Col.', 'Col. (Ret.)', 'Cpl.', 'Count', 'Countess', 'Dean', 'Dr.', 'Duke', 'Ens.', 'Fr.', 'Frau', 'Gen.', 'Gov.', 'Judge', 'Justice', 'Lord', 'Lt.', '2Lt.', '2dLt.', 'Lt. Cmdr.', 'Lt. Col.', 'Lt. Gen.', 'Lt. j.g.', 'Mlle.', 'Maj.', 'Master', 'Master Sgt.', 'Miss', 'Mme.', 'MIDN', 'M.', 'Msgr.', 'Mr.', 'Mrs.', 'Ms.', 'Mx.', 'Pres.', 'Princess', 'Prof.', 'Rabbi', 'R.Adm.', 'Rep.', 'Rev.', 'Rt.Rev.', 'Sgt.', 'Sen.', 'Sr.', 'Sra.', 'Srta.', 'Sheikh', 'Sir', 'Sr.', 'S. Sgt.', 'The Hon.', 'The Venerable', 'V.Adm.').freeze
  NameSuffix = Strict::String.enum('B.A.', 'B.F.A.', 'B.F.D', 'B.M.', 'B.S.', 'B.S.E.E.', 'D.A.', 'D.B.A.', 'D.D.S.', 'D.M.L.', 'D.Min.','D.P.T.', 'Ed.D.', 'Ed.M.', 'J.D.', 'M.A.', 'M.B.A.', 'M.Div.', 'M.F.A.', 'M.D.', 'M.M.', 'M.P.A.', 'M.Phil.', 'M.S.', 'M.S.A.', 'M.S.E.E.', 'M.S.L.I.S.', 'M.S.P.T.', 'M.Th.', 'Ph.D.', 'R.N.', 'S.T.M.', 'Th.D.').freeze
end

class Friend < ApplicationRecord
end

# Create a name contract that allows for storage of all parts of a name.
class NameContract < Dry::Validation::Contract
  params do
    optional(:name_title).filled(Types::NameTitle)
    required(:name_first).filled(Types::Coercible::String.constrained(max_size: 32))
    optional(:name_middle).filled(Types::Coercible::String.optional.constrained(max_size: 32))
    required(:name_last).filled(Types::Coercible::String.constrained(max_size: 32))
    optional(:name_suffix).filled(Types::NameSuffix)
  end
end

# define the contact information desired to be collected
class ContactContract < Dry::Validation::Contract
  params do
    required(:email_1).filled(Types::Email)
    optional(:email_2).filled(Types::Nil | Types::Email)
    optional(:phone_1).filled(Types::PhoneNumber)
    optional(:phone_2).filled(Types::Nil | Types::PhoneNumber)
    optional(:twitter_handle).filled(Types::Nil | Types::TwitterHandle)
  end
end

# define the contact information desired to be collected
class DemographicsContract < Dry::Validation::Contract
  params do
    optional(:dob).filled(Types::AllDatesToUSDate)
    optional(:sex).filled(Types::String.constrained(max_size: 6))
    optional(:occupation).filled(Types::String.constrained(max_size: 32))
    optional(:available_to_party).filled(Types::Bool)
  end
end

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

class GeolocationContract < Dry::Validation::Contract
  params do
    optional(:latitude).filled(Types::Nil | Types::Latitude)
    optional(:longitude).filled(Types::Nil | Types::Longitude)
    optional(:lat_long_location_precision).filled(Types::Nil | Types::String.constrained(max_size: 18))
  end
end