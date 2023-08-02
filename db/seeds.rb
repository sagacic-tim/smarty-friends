# This file should contain all the record creations needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

friends = Friend.create!([
{
    name_title: "Sir",
    name_first: "Timothy",
    name_middle: "Edgar",
    name_last: "Michel",
    name_suffix: "VIII",
    email_1: "tmichel@sagacicweb.com",
    email_2: "edgar_michel@hotmail.com",
    phone_1: "+16264833220",
    phone_2: "+19097640044",
    twitter_handle: "@tmichel",
    dob: "October 17, 2001",
    sex: "Trans",
    occupation: "Professional Partier",
    available_to_party: true,
    delivery_line_1: "",
    last_line: "", 
    street_number: "1404",
    street_predirection: "",
    street_name: "Rodney",
    street_suffix: "Road",
    street_postdirection: "",
    city: "West Covina",
    county: "",
    state_abbreviation: "CA",
    country: "",
    country_code: "",
    postal_code: "",
    zip_plus_4_extension: "",
    latitude: "",
    longitude: "",
    lat_long_location_precision: ""
}])