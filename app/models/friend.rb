require 'dotenv'
require "smartystreets_ruby_sdk/client_builder"
require "smartystreets_ruby_sdk/static_credentials"
require "smartystreets_ruby_sdk/shared_credentials"
require "smartystreets_ruby_sdk/us_street/lookup"
require "smartystreets_ruby_sdk/us_street/match_type"
# require 'dry/types'
# require_relative '../lib/tasks/decimal_types'
# require 'colorize' # Extends String class
# require 'colorized_string' # add ColorizedString class

class Friend < ApplicationRecord
   store_accessor :address, :delivery_line_1, :last_line, :delivery_point_bar_code, :street_number, :street_name, :street_suffix, :city, :county, :county_FIPS, :state_abbreviation, :country, :country_code, :postal_code, :zip_plus_4_extension, :zip_type, :delivery_point, :delivery_point_check_digit, :carrier_route, :record_type, :latitude, :longitude
   store_accessor :name, :name_title, :name_first, :name_middle, :name_last, :name_suffix

    validates :name_title, :name_first, :name_middle, :name_last, :name_suffix, presence: true, allow_nil: true, format: { with: /\A(?:[A-Za-z]+\.)?\s*[A-Za-z]+\s*(?:[A-Za-z]+\s*)*(?:[A-Za-z]+\s*)?\z/, message: "Should contain at least a valid first name and last name. Title, middle name and name suffix are optional — only alpha numeric characters and .,' and spaces" } 
    validates :phone, phone: true, allow_blank: true
    validates :twitter_handle, presence: true, allow_blank: true, format: { with: /\A(\@)?([a-z0-9_]{1,15})$\z/, message: "please enter a valid twitter name"}
    validates :email, email: {mode: :strict, require_fqdn: true}
    validates :available_to_party, inclusion: [true, false]

    serialize :original_attributes
    serialize :verification_info

    before_validation :validate_address_with_smartystreets

    def validate_address_with_smartystreets
        address_hash = self.address

        address_string = "#{address_hash["street_number"]} #{address_hash["street_name"]} #{address_hash["street_suffix"]}, #{address_hash["city"]} #{address_hash["state_abbreviation"]} #{address_hash["country"]} #{address_hash["postal_code"]}"

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
            puts 'No candidates. This means the address is not valid.\n\n'
            return
        end

        first_candidate = result[0]

        if lookup.match == :strict
            puts "At least one candidate returned.\n\nMatch parameter is set to " + lookup.match.to_s + ", The API will return detailed output only if a valid match is found. Otherwise the API response will be an empty array.\n\n"
        elsif lookup.match == :enhanced
            puts "At least one candidate returned.\n\nMatch parameter is set to " + lookup.match.to_s + ", The API will return detailed output based on a more aggressive matching mechanism. It also includes a more comprehensive address dataset beyond just the postal address data. Requires a US Core license or a US Rooftop Geocoding license. Note: A freeform address, that we can't find a match for, will respond with an empty
            array, \"\[\]\".\n\n" 
        elsif lookup.match == :invalid
            puts "Many candidates are possible matches.\n\nMatch parameter is set to " + lookup.match.to_s + ", The API will return detailed output for both valid and invalid addresses. To find out if the address is valid, check the dpv_match_code. Values of Y, S, or D indicate a valid address.\n\n"
        else
            puts "Invalid match type" + "\n\n"
        end

        address_hash["delivery_line_1"] = first_candidate.delivery_line_1
        address_hash["last_line"] = first_candidate.last_line
        address_hash["delivery_point_bar_code"] = first_candidate.delivery_point_barcode
        address_hash["street_number"] = first_candidate.components.primary_number
        address_hash["street_name"] =  first_candidate.components.street_name
        address_hash["street_suffix"] = first_candidate.components.street_suffix
        address_hash["city"] = first_candidate.components.city_name
        address_hash["county"] = first_candidate.metadata.county_name
        address_hash["county_FIPS"] = first_candidate.metadata.county_fips
        address_hash["state_abbreviation"] = first_candidate.components.state_abbreviation
        address_hash["postal_code"] = first_candidate.components.zipcode
        address_hash["zip_plus_4_extension"] = first_candidate.components.plus4_code
        address_hash["zip_type"] = first_candidate.metadata.zip_type
        address_hash["delivery_point"] = first_candidate.components.delivery_point
        address_hash["delivery_point_check_digit"] = first_candidate.components.delivery_point_check_digit
        address_hash["carrier_route"] = first_candidate.metadata.carrier_route
        address_hash["record_type"] = first_candidate.metadata.record_type
        address_hash["latitude"] = "#{first_candidate.metadata.latitude}"
        address_hash["longitude"] = "#{first_candidate.metadata.longitude}"
        self.address = address_hash
    end
end
