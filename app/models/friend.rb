
require 'smartystreets_ruby_sdk'

class Friend < ApplicationRecord
  geocoded_by :address 
  extend Geocoder::Model::ActiveRecord
  validates :name_first, presence: true, format: { with: /\A(?:[A-Za-z]+\.)?\s*[A-Za-z]+\s*(?:[A-Za-z]+\s*)*(?:[A-Za-z]+\s*)?\z/, message: "should contain a valid title, full name, and optional suffix" }
  validates :phone, phone: true, allow_blank: true
  validates :twitter, presence: true, format: { with: /\A(\@)?([a-z0-9_]{1,15})$\z/, message: "please enter a valid twitter name"}
  validates :email, email: {mode: :strict, require_fqdn: true}
  validates :street_name, presence: true
  # validate :address_validation, if: -> { something_changed? }
  validates :available_to_party, presence: true

  serialize :original_attributes
  serialize :verification_info
end