source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# A simple definition of Dotenv “Dotenv is a Ruby Gem that
# loads variables from a .env file into ENV when the envir-
# onment is bootstrapped.”
gem 'dotenv-rails', :groups => [:development, :test]

# Bundle edge Rails instead: gem "rails", github: "rails/rails",
# branch: "main"
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
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Rack::Cors provides support for Cross-Origin Resource
# Sharing (CORS) for Rack compatible web applications.
gem 'rack-cors', '~> 1.1', '>= 1.1.1'
 
# Google libphonenumber library was taken as a basis for
# this gem. Gem uses its data file for validations and
# number formatting.
gem 'phonelib', '~> 0.8.1'

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
gem 'dry-types', '~> 1.7'

# dry-struct is a gem built on top of dry-types which provides
# virtus-like DSL for defining typed struct classes.
gem 'dry-struct', '~> 1.6'

# Ruby gem for colorizing text using ANSI escape sequences.
# Extends String class or add a ColorizedString with methods
# to set the text color, background color and text effects.
gem 'colorize'

group :development, :test do
  # This library provides debugging functionality to Ruby (MRI) 2.6
  # and later.
  # This debug.rb is replacement of traditional lib/debug.rb
  # standard library which is implemented by set_trace_func. New
  #debug.rb has several advantages:
  # See: https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", ">= 1.0.0"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'annotate', git: 'https://github.com/ctran/annotate_models.git'
end