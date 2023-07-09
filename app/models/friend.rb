require "smartystreets_ruby_sdk/client_builder"
require "smartystreets_ruby_sdk/static_credentials"
require "smartystreets_ruby_sdk/shared_credentials"
require "smartystreets_ruby_sdk/us_street/lookup"
require "smartystreets_ruby_sdk/us_street/match_type"

class Friend < ApplicationRecord
  store_accessor :address,
    :street_number,
    :street_name,
    :street_suffix,
    :city,
    :state_province,
    :country,
    :country_code,
    :postal_code

  validates_presence_of :street_number, :street_name, :city, :state_province, :country, :postal_code
  validates :phone, phone: true, allow_blank: true
  validates :twitter_handle, presence: true, format: { with: /\A(\@)?([a-z0-9_]{1,15})$\z/, message: "please enter a valid twitter name"}
  validates :email, email: {mode: :strict, require_fqdn: true}
  validate :validate_address_with_smartystreets
  validates_presence_of :available_to_party

  serialize :original_attributes
  serialize :verification_info

  private

  def validate_address_with_smartystreets
    puts "street_number: " + street_number
    puts "street_name: " + street_name
    puts "street_suffix: " + street_suffix
    puts "city: " + city
    puts "state_province: " + state_province
    puts "country: " + country
    puts "postal_code: " + postal_code

    address_string = "#{street_number} #{street_name} #{street_suffix}, #{city}, #{state_province}, #{country}, #{postal_code}"
    puts "address string: " + address_string

    # Call SmartyStreets API to validate the address
    app_auth_id = Rails.application.credentials.dig(:smarty_streets, :auth_id)
    app_auth_token = Rails.application.credentials.dig(:smarty_streets, :auth_token)
    puts app_auth_id
    puts app_auth_token
    credentials = SmartyStreets::StaticCredentials.new(app_auth_id, app_auth_token)
    client = SmartyStreets::ClientBuilder.new(credentials).build_us_street_api_client
    lookup = SmartyStreets::USStreet::Lookup.new(address_string) # Pass the address string as an argument

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

    puts "There is at least one candidate.\n If the match parameter is set to STRICT, the address is valid.\n Otherwise, check the Analysis output fields to see if the address is valid.\n"
    puts "ZIP Code: #{first_candidate.components.zipcode}"
    puts "County: #{first_candidate.metadata.county_name}"
    puts "Latitude: #{first_candidate.metadata.latitude}"
    puts "Longitude: #{first_candidate.metadata.longitude}"
  end
end