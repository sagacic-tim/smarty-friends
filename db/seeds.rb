# This file should contain all the record creations needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

friend_data = {
    name_title: 'Sir',
    name_first: 'Timothy',
    name_middle: 'Edgar',
    name_last: 'Michel',
    name_suffix: 'VIII',
    email_1: 'tmichel@sagacicweb.com',
    email_2: 'edgar_michel@hotmail.com',
    phone_1: '+16264833220',
    phone_2: '+19097640044',
    twitter_handle: '@tmichel',
    dob: Date.parse('2001-10-17'),
    sex: 'Trans',
    occupation: 'Professional Partier',
    available_to_party: true,
    street_number: '1404',
    street_name: 'Rodney',
    street_suffix: 'Road',
    city: 'West Covina',
    state_abbreviation: 'CA'
}
  
  # Add the friend_data hash to the Friend.create! method
  Friend.create!(friend_data)