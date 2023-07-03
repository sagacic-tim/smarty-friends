# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
friends = Friend.create([
    {name: 
    {name_title: "Mr.",
    name_first: "Timothy",
    name_middle: "Edgar",
    name_last: "Michel",
    name_suffix: ""
    },
    phone: "+16264833220",
    twitter: "@tmichel",
    email: "tmichel@sagacicweb.com",
    address:
    {
    street_number: "1404",
    street_name: "Rodney",
    street_suffix: "Road",
    city: "West Covina",
    state_province: "California",
    country: "United States",
    country_code: "US",
    postal_code: "91792",
    latitude: "34.033730",
    longitude: "-117.915240"
    }
    available_to_party: "no"
    },

    {name:
    {name_title: "",
    name_first: "Christopher",
    name_middle: "",
    name_last: "Gruener",
    name_suffix: "MS LPC"
    },
    phone: "+16179656552",
    twitter: "@cgruener",
    email: "c.gruener@comcast.net",
    address {
    street_number: "72",
    street_name: "Langley",
    street_suffix: "Road",
    city: "Newton Center",
    state_province: "Massachusetts",
    country: "United States",
    country_code: "US",
    postal_code: "02459",{}
    latitude: "34.033730",
    longitude: "-117.915240"
    },
    available_to_party: "yes"},
])