# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# require 'dry/types'
# require_relative '../lib/tasks/decimal_types'

friends = Friend.create!([
{
    name: {
        name_title: "Sir",
        name_first: "Timothy",
        name_middle: "Edgar",
        name_last: "Michel",
        name_suffix: "VIII"
    },
    phone: "+16264833220",
    twitter_handle: "@tmichel",
    email: "tmichel@sagacicweb.com",
    address: {
        delivery_line_1: "",
        last_line: "",
        delivery_point_bar_code: "", 
        street_number: "1404",
        street_name: "Rodney",
        street_suffix: "Road",
        city: "West Covina",
        county: "",
        county_FIPS: "",
        state_abbreviation: "CA",
        country: "",
        country_code: "US",
        postal_code: "",
        zip_plus_4_extension: "",
        zip_type: "",
        delivery_point: "",
        delivery_point_check_digit: "",
        carrier_route: "",
        record_type: "",
        latitude: "",
        longitude: ""
    },
    available_to_party: false
}])