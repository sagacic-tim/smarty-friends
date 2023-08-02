source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# A simple definition of Dotenv “Dotenv is a Ruby Gem that
# loads variables from a .env file into ENV when the envir-
# onment is bootstrapped.”
gem 'dotenv-rails', :groups => [:development, :test]

# Bundle edge Rails instead: gem "rails", github: "rails/rails",
gem "rails", "~> 7.0.4", ">= 7.0.4.3"

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5', '>= 1.5.3'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 6.3'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1", "~> 3.1.13"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Rack::Cors provides support for Cross-Origin Resource
# Sharing (CORS) for Rack compatible web applications.
gem 'rack-cors', '~> 1.1', '>= 1.1.1'
 
# Phonelib is a gem allowing you to validate phone numbers.
# All validations are based on Google libphonenumber. Cur-
# rently it can make basic validations and formatting to
# e164 international number format and national number for-
# mat with prefix. But it still doesn’t include all Google’s
# library functionality.
gem 'phonelib', '~> 0.8', '~> 0.8.2'

# The activerecord-postgis-adapter provides access to
# features of the PostGIS geospatial database from
# ActiveRecord. It extends the standard postgresql adapter
# to provide support for the spatial data types and features
# added by the PostGIS extension. It uses the RGeo library
# to represent spatial data in Ruby.
gem 'activerecord-postgis-adapter'

#  Here are a few examples showing how to use the Ruby SDK:
#
#   Verifying US street addresses
#   Verifying international street addresses
#   Finding US ZIP Codes
#   Extracting US street addresses from arbitrary text
#   Completing US street addresses given an prefix
#
gem 'smartystreets_ruby_sdk', '~> 5.14', '>= 5.14.19'

# MainStreet uses Geocoder for address verification, which
# has a number of 3rd party services you can use. If you
# adhere to GDPR, be sure to add the service to your sub-
# processor list.
gem "mainstreet"

# Provides object geocoding (by street or IP address),
# reverse geocoding (coordinates to street address),
#distance queries for ActiveRecord and Mongoid, result
# caching, and more. Designed for Rails but works with
# Sinatra and other Rack frameworks too.
gem 'geocoder', '~> 1.3', '>= 1.3.7'

# An email validator for Rails 3+
# The default validation provided by this gem (the :loose
# configuration option) is extremely loose. It just checks
# that there's an @ with something before and after it
# without any whitespace.
#
# We understand that many use cases require an increased
# level of validation. This is supported by using the
# :strict validation mode.
gem 'email_validator'

# gem 'country_select' provides a simple helper to get an
# HTML select list of countries using the ISO 3166-1 standard.
#
# While the ISO 3166 standard is a relatively neutral source
# of country names, it may still offend some users. Developers
# are strongly advised to evaluate the suitability of this
# list given their user base.
gem 'country_select', '~> 8.0'

# dry-types is a simple and extendable type system for Ruby;
# useful for value coercions, applying constraints, defining
# complex structs or value objects and more. It was created
# as a successor to Virtus.
gem 'dry-types', '~> 1.7', '~> 1.7.1'

# dry-struct is a gem built on top of dry-types which provides
# virtus-like DSL for defining typed struct classes.
gem 'dry-struct', '~> 1.6', '~> 1.6.0'

# dry-validation is a data validation library that provides a
# powerful DSL for defining schemas and validation rules.
#
# Validations are expressed through contract objects. A contract
# specifies a schema with basic type checks and any additional
# rules that should be applied. Contract rules are applied only
# once the values they rely on have been succesfully verified by
# the schema.
gem 'dry-validation', '~> 1.10', '~> 1.10.0'

# dry-monads is a set of common monads for Ruby. Monads provide
# an elegant way of handling errors, exceptions and chaining
# functions so that the code is much more understandable and has
# all the error handling, without all the ifs and elses.
gem 'dry-monads', '~> 1.6', '~> 1.6.0'

# dry-configurable is a simple mixin to add thread-safe configur-
# ation behavior to your classes. There are many libraries that
# make use of the configuration, and each seemed to have its own
# implementation with a similar or duplicate interface, so we
# thought it was strange that this behavior had not already been
# encapsulated into a reusable gem, hence dry-configurable was born.
gem 'dry-configurable', '~> 1.1', '~> 1.1.0'

# Object dependency management system based on dry-container and
# dry-auto_inject allowing you to configure reusable components
# in any environment, set up their load-paths, require needed files
# and instantiate objects automatically with the ability to have#
# them injected as dependencies.

gem 'dry-system', '~> 1.0', '~> 1.0.1'

# Ruby gem for colorizing text using ANSI escape sequences.
# Extends String class or add a ColorizedString with methods
# to set the text color, background color and text effects.
gem 'colorize'

# BigDecimal provides similar support for very large or very
# accurate floating point numbers. Decimal arithmetic is also
# useful for general calculation, because it provides the correct
# answers people expect–whereas normal binary floating point
# arithmetic often introduces subtle errors because of the con-
# version between base 10 and base 2.
gem 'bigdecimal', '~> 3.1', '>= 3.1.4'

group :development, :test do
  # This library provides debugging functionality to Ruby (MRI) 2.6
  # and later.
  # This debug.rb is replacement of traditional lib/debug.rb
  # standard library which is implemented by set_trace_func. New
  # debug.rb has several advantages:
  # See: https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", ">= 1.0.0"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'annotate', git: 'https://github.com/ctran/annotate_models.git'
end
