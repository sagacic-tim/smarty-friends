require "smartystreets_ruby_sdk/client_builder"
require "smartystreets_ruby_sdk/static_credentials"
require "smartystreets_ruby_sdk/us_street"

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
    auth_id = ENV['SMARTY_STREETS_AUTH_ID']
    auth_token = ENV['SMARTY_STREETS_AUTH_TOKEN']
    client = SmartyStreets::ClientBuilder.new(auth_id, auth_token).build
    client.send_lookup(lookup)
    

    if lookup.empty?
      errors.add(:address, "is not valid")
    elsif !lookup[0].analysis.verified?
      errors.add(:address, "could not be verified")
    end
    rescue SmartyStreets::SmartyError => e
    errors.add(:address, "encountered an error: #{e.message}")
  end
end