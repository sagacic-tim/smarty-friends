# app/models/friend.rb
# Gem Requirements
require "smartystreets_ruby_sdk/client_builder"
require "smartystreets_ruby_sdk/static_credentials"
require "smartystreets_ruby_sdk/us_street/lookup"
require 'bigdecimal'
require 'dry-types'
require 'dry-validation'
require_relative 'concerns/friend_types/all_dates_to_us_date.rb'
require_relative 'concerns/friend_types/email_type.rb'
require_relative 'concerns/friend_types/latitude_type.rb'
require_relative 'concerns/friend_types/longitude_type.rb'
require_relative 'concerns/friend_types/name_title_type.rb'
require_relative 'concerns/friend_types/name_suffix_type.rb'
require_relative 'concerns/friend_types/phone_number_type.rb'
require_relative 'concerns/friend_types/twitter_handle_type.rb'

class Friend < ApplicationRecord
  include Types # This will include the Dry::Types module

  # Define attributes based on the contracts
  attribute :name_title, Types::NameTitleType
  attribute :name_first, Types::Coercible::String.constrained(max_size: 32)
  attribute :name_middle, Types::Coercible::String.optional.constrained(max_size: 32)
  attribute :name_last, Types::Coercible::String.constrained(max_size: 32)
  attribute :name_suffix, Types::NameSuffixType
  attribute :email_1, Types::EmailType
  attribute :email_2, Types::Nil | Types::EmailType
  attribute :phone_1, Types::PhoneNumberType
  attribute :phone_2, Types::Nil | Types::PhoneNumberType
  attribute :twitter_handle, Types::Nil | Types::TwitterHandleType
  attribute :dob, Types::AllDatesToUSDate
  attribute :sex, Types::String.constrained(max_size: 6)
  attribute :occupation, Types::String.constrained(max_size: 32)
  attribute :available_to_party, Types::Bool
  attribute :latitude, Types::Nil | Types::LatitudeType
  attribute :longitude, Types::Nil | Types::LongitudeType
  attribute :lat_long_location_precision, Types::Nil | Types::String.constrained(max_size: 18)
  attribute :delivery_line_1, Types::String.constrained(max_size: 50)
  attribute :last_line, Types::String.constrained(max_size: 50)
  attribute :street_number, Types::String.constrained(max_size: 30)
  attribute :street_predirection, Types::String.constrained(max_size: 16)
  attribute :street_name, Types::String.constrained(max_size: 64)
  attribute :street_suffix, Types::String.constrained(max_size: 16)
  attribute :street_postdirection, Types::String.constrained(max_size: 16)
  attribute :city, Types::String.constrained(max_size: 64)
  attribute :state_abbreviation, Types::String.constrained(max_size: 2)
  attribute :country, Types::String.default('United States').constrained(max_size: 32)
  attribute :country_code, Types::String.default('US').constrained(max_size: 4)
  attribute :postal_code, Types::String.constrained(max_size: 5)
  attribute :zip_plus_4_extension, Types::String.constrained(max_size: 4)
end