require "smartystreets_ruby_sdk/client_builder"
require "smartystreets_ruby_sdk/static_credentials"
require "smartystreets_ruby_sdk/shared_credentials"
require "smartystreets_ruby_sdk/us_street/lookup"
require "smartystreets_ruby_sdk/us_street/match_type"
# require 'dry/types'
# require_relative '../lib/tasks/decimal_types'

class Friend < ApplicationRecord
    store_accessor :address, :delivery_line_1, :last_line, :delivery_point_bar_code, :street_number, :street_name, :street_suffix, :city, :county, :county_FIPS, :state_abbreviation, :country, :country_code, :postal_code, :zip_plus_4_extension, :zip_type, :delivery_point, :delivery_point_check_digit, :carrier_route, :record_type, :latitude, :longitude
        
    store_accessor :name, :name_title, :name_first, :name_middle, :name_last, :name_suffix

    validates :name_title, :name_first, :name_middle, :name_last, :name_suffix, presence: true, allow_nil: true, format: { with: /\A(?:[A-Za-z]+\.)?\s*[A-Za-z]+\s*(?:[A-Za-z]+\s*)*(?:[A-Za-z]+\s*)?\z/, message: "should contain at least a valid first name and last name. Title, middle name and name suffix are optional" } 
    validate :show_full_name
    validates :phone, phone: true, allow_blank: true
    validates :twitter_handle, presence: true, format: { with: /\A(\@)?([a-z0-9_]{1,15})$\z/, message: "please enter a valid twitter name"}
    validates :email, email: {mode: :strict, require_fqdn: true}
    validates_presence_of :street_number, :street_name, :city, :state_abbreviation, :country, :postal_code
    validate :validate_address_with_smartystreets
    validates_presence_of :available_to_party

    serialize :original_attributes
    serialize :verification_info

    private

    def show_full_name
        full_name ="#{name_title} #{name_first} #{name_middle} #{name_last} #{name_suffix}"
        puts "\nFull Name: " + full_name + "\n\n"
    end

    def validate_address_with_smartystreets

        address_string = "#{street_number} #{street_name} #{street_suffix}, #{city} #{state_abbreviation} #{country} #{postal_code}"
        puts "Address data sent to Smarty: " + address_string + "\n\n"

        # Call SmartyStreets API to validate the address
        app_auth_id = Rails.application.credentials.dig(:smarty_streets, :auth_id)
        app_auth_token = Rails.application.credentials.dig(:smarty_streets, :auth_token)
        puts "app_auth_id: " + app_auth_id
        puts "app_auth_token: " + app_auth_token + "\n\n"
        credentials = SmartyStreets::StaticCredentials.new(app_auth_id, app_auth_token)
        client = SmartyStreets::ClientBuilder.new(credentials).build_us_street_api_client
        lookup = SmartyStreets::USStreet::Lookup.new(address_string) # Pass the address string as an argument
        lookup.match = 'STRICT' # Only valid addresses returned.

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

        puts "There is at least one candidate.\n\nThe match parameter IS set to STRICT, this means the address IS valid.\n\n"
        delivery_line_1 = "#{first_candidate.delivery_line_1}"
        last_line = "#{first_candidate.last_line}"
        delivery_point_bar_code = "#{first_candidate.delivery_point_barcode}"
        street_number = "#{first_candidate.components.primary_number}"
        street_name =  "#{first_candidate.components.street_name}"
        street_suffix = "#{first_candidate.components.street_suffix}"
        city = "#{first_candidate.components.city_name}"
        county = "#{first_candidate.metadata.county_name}"
        county_FIPS = "#{first_candidate.metadata.county_fips}"
        state_abbreviation = "#{first_candidate.components.state_abbreviation}"
        postal_code = "#{first_candidate.components.zipcode}"
        zip_plus_4_extension = "#{first_candidate.components.plus4_code}"
        zip_type = "#{first_candidate.metadata.zip_type}"
        delivery_point = "#{first_candidate.components.delivery_point}"
        delivery_point_check_digit = "#{first_candidate.components.delivery_point_check_digit}"
        carrier_route = "#{first_candidate.metadata.carrier_route}"
        record_type = "#{first_candidate.metadata.record_type}"
        latitude = "#{first_candidate.metadata.latitude}"
        longitude = "#{first_candidate.metadata.longitude}"

        puts "*** Address data returned from Smarty and copied to hstore record ***\n\n"
        puts "Delivery Line 1: " + delivery_line_1
        puts "Last Line: " + last_line
        puts "Delivery Point Bar Code: " + delivery_point_bar_code
        puts "Street Number: " + street_number
        puts "Street Name: " + street_name
        puts "Street Suffix: " + street_suffix
        puts "City: " + city
        puts "County: " + county
        puts "County FIPS: " + county_FIPS
        puts "State Abbreviation: " + state_abbreviation
        puts "Zip Code: " + postal_code
        puts "Zip Plus 4 Extension: " + zip_plus_4_extension
        puts "Zip Type: " + zip_type
        puts "Delivery Point: " + delivery_point
        puts "Delivery Point Check Digit: " + delivery_point_check_digit
        puts "Carrier Route: " + carrier_route
        puts "Record Type: " + record_type
        puts "Latitude: " + latitude
        puts "Longitude: " + longitude
    end
end