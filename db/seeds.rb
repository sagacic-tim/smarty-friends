# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# require_relative '../lib/tasks/decimal_types'

friends = Friend.create([
{
    name: {
        name_title: "Mr.",
        name_first: "Timothy",
        name_middle: "Edgar",
        name_last: "Michel",
        name_suffix: ""
    },
    phone: "+16264833220",
    twitter_handle: "@tmichel",
    email: "tmichel@sagacicweb.com",
    address: {
        street_number: "1404",
        street_name: "Rodney",
        street_suffix: "Road",
        city: "West Covina",
        state_province: "California",
        country: "United States",
        country_code: "US",
        postal_code: "91792",
    },
    map_coordinates: {
        latitude: "34.033730",
        longitude: "-117.915240"
    },
    available_to_party: "no"
}])