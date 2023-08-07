require 'dry-types'
require 'dry-logic'
require 'date'

module Types
  include Dry.Types()

  class AllDatesToUSDate < Dry::Types::Definition
    DATE_FORMATS = [
      '%Y-%m-%d', '%m/%d/%Y', '%d/%m/%Y', '%Y/%m/%d',
      '%m-%d-%Y', '%d-%m-%Y', '%Y-%m-%d', '%Y%m%d',
      '%B %d, %Y', '%Y %B %d'
    ].freeze

    def initialize(type = Dry::Types['strict.string'])
      super(type.constructor(&method(:parse_date)).constrained(&method(:validate_date)))
    end

    private

    def parse_date(value)
      DATE_FORMATS.each do |format|
        parsed_date = Date.strptime(value, format) rescue nil
        return parsed_date.strftime('%m/%d/%Y') if parsed_date
      end

      raise Dry::Types::CoercionError.new("Invalid date format: #{value}")
    end

    def validate_date(value)
      return value if parse_date(value) # Check if the date can be parsed successfully
      raise Dry::Types::ConstraintError.new("Invalid date: #{value}")
    end
  end
end