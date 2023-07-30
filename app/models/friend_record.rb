# app/models/friend_record.rb – This is a dummy class that is
# populated with data from Dry::Struct class FriendService
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
      delivery_line_1: address_data['delivery_line_1'],
      last_line: address_data['last_line'],
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
  end
end