require 'sanitize'

module ActiveDynamic
  class Attribute < ActiveRecord::Base
    belongs_to :customizable, polymorphic: true
    belongs_to :active_dynamic_definition, class_name: 'ActiveDynamic::AttributeDefinition', required: true

    before_validation :sanitize

    validate :no_greater_than_128

    self.table_name = :active_dynamic_attributes

    def no_greater_than_128
      errors.add(:value, "Value cannot be longer than 128 characters.") if value&.size&.> 128
    end

    def sanitize
      # strip all html. Remove all whitespace
      self.value = Sanitize.fragment(self.value)
    end
  end
end
